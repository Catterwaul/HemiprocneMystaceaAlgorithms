import Combine

public extension Unowned {
  @propertyWrapper final class Collection<WrappedValue: Swift.Collection> {
    public var wrappedValue: WrappedValue
    private var cancellable: AnyCancellable!

    public init(
      wrappedValue: WrappedValue,
      objects: some Sequence<Object>,
      deinit: @escaping (Collection, Object) -> Void
    ) {
      self.wrappedValue = wrappedValue
      cancellable = Publishers.MergeMany(objects.lazy.map(\.deinitPublisher))
        .sink { [unowned self] in `deinit`(self, $0) }
    }
  }

  typealias Dictionary<Key: Hashable> = Collection<[Key: Unowned]>
}

public extension Unowned.Collection {
  @inlinable convenience init<Key>(
    _ objects: some Sequence<Object>,
    key keyForValue: @escaping (Object) -> Key
  ) where WrappedValue == [Key: Unowned] {
    self.init(
      wrappedValue: .init(
        uniqueKeysWithValues: objects.lazy.map { (keyForValue($0), .init(wrappedValue: $0)) }
      ),
      objects: objects,
      deinit: { collection, object in
        collection.wrappedValue[keyForValue(object)] = nil
      }
    )
  }
}
