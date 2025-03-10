import Combine

/// An unowned reference to a `Deinitializing` object.
///
/// This will be useful until a hypothetical time when Swift might have native unowned-referencing collections.
@propertyWrapper public struct Unowned<Object: Deinitializing & AnyObject> {
  public init(wrappedValue: Object) {
    self.wrappedValue = wrappedValue
    cancellable = wrappedValue.deinitPublisher.subscribe(deinitPublisher)
  }

  public unowned let wrappedValue: Object
  private let deinitPublisher = PassthroughSubject<Object, Never>()
  private let cancellable: AnyCancellable
}

// MARK: - Equatable
extension Unowned: Equatable where Object: Equatable {
  public static func == (unowned0: Self, unowned1: Self) -> Bool {
    unowned0.wrappedValue == unowned1.wrappedValue
  }
}

// MARK: - Hashable
extension Unowned: Hashable where Object: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(wrappedValue.hashValue)
  }
}
