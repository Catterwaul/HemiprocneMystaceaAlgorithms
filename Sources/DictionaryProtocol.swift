import typealias OrderedCollections.OrderedDictionary

public protocol DictionaryProtocol<Key, Value>: Sequence & ExpressibleByDictionaryLiteral
where Element == (key: Key, value: Value) {
  associatedtype Key
  associatedtype Value

  /// Group key-value pairs by their keys.
  ///
  /// - Parameter pairs: Either `KeyValuePairs<Key, Value.Element>`
  ///   or a `Sequence` with the same element type as that.
  /// - Returns: `[Key: [ValueElement]]`
  init<ValueElement>(grouping pairs: some Sequence<(key: Key, value: ValueElement)>)
  where Value == [ValueElement]

  /// Group key-value pairs by their keys.
  ///
  /// - Parameter pairs: Like `KeyValuePairs<Key, Value.Element>`,
  ///   but with unlabeled elements.
  /// - Returns: `[Key: [ValueElement]]`
  init<ValueElement>(grouping pairs: some Sequence<(Key, ValueElement)>)
  where Value == [ValueElement]
}

extension Dictionary: DictionaryProtocol { }
extension OrderedDictionary: DictionaryProtocol { }


// MARK: - cannot be represented within DictionaryProtocol
public extension Dictionary {
  @inlinable init<ValueElement>(grouping pairs: some Sequence<(key: Key, value: ValueElement)>)
  where Value == [ValueElement] {
    self = [_: _](grouping: pairs, by: \.key).mapValues { $0.map(\.value) }
  }

  @inlinable init<ValueElement>(grouping pairs: some Sequence<(Key, ValueElement)>)
  where Value == [ValueElement] {
    self.init(grouping: pairs.lazy.map { (key: $0, value: $1) })
  }
}

public extension OrderedDictionary {
  @inlinable init<ValueElement>(grouping pairs: some Sequence<(key: Key, value: ValueElement)>)
  where Value == [ValueElement] {
    self = OrderedDictionary<_, _>(grouping: pairs, by: \.key)
      .mapValues { $0.map(\.value) }
  }

  @inlinable init<ValueElement>(grouping pairs: some Sequence<(Key, ValueElement)>)
  where Value == [ValueElement] {
    self.init(grouping: pairs.lazy.map { (key: $0, value: $1) })
  }
}
