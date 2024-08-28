import typealias OrderedCollections.OrderedDictionary
import Cast
import Tuplé

public protocol DictionaryProtocol<Key, Value>: Sequence & ExpressibleByDictionaryLiteral
where Element == (key: Key, value: Value) {
  // MARK: - from the standard library
  associatedtype Key
  associatedtype Keys: Sequence<Key>
  associatedtype Value

  init(uniqueKeysWithValues: some Sequence<(Key, Value)>)

  init(
    _: some Sequence<(Key, Value)>,
    uniquingKeysWith: (Value, Value) throws -> Value
  ) rethrows

  subscript(key: Key) -> Value? { get set }
  subscript(key: Key, default _: @autoclosure () -> Value) -> Value { get set }

  var keys: Keys { get }

  mutating func merge(
    _: some Sequence<(Key, Value)>,
    uniquingKeysWith: (Value, Value) throws -> Value
  ) rethrows

  func merging(
    _: Self,
    uniquingKeysWith combine: (Value, Value) throws -> Value
  ) rethrows -> Self

  // MARK: - defined in this file
  /// Group key-value pairs by their keys.
  ///
  /// **Returns:** `[Key: [ValueElement]]`
  /// - Parameter pairs: Either `KeyValuePairs<Key, Value.Element>`
  ///   or a `Sequence` with the same element type as that.
  init<ValueElement>(grouping pairs: some Sequence<(key: Key, value: ValueElement)>)
  where Value == [ValueElement]

  /// Group key-value pairs by their keys.
  ///
  /// **Returns:** `[Key: [ValueElement]]`.
  /// - Parameter pairs: Like `KeyValuePairs<Key, Value.Element>`,
  ///   but with unlabeled elements.
  init<ValueElement>(grouping pairs: some Sequence<(Key, ValueElement)>)
  where Value == [ValueElement]
}

extension Dictionary: DictionaryProtocol { }
extension OrderedDictionary: DictionaryProtocol { }

public extension DictionaryProtocol {
  // MARK: - Initializers

  /// Creates a new dictionary from the key-value pairs in the given sequence.
  ///
  /// - Parameter keysAndValues: A sequence of key-value pairs to use for
  ///   the new dictionary. Every key in `keysAndValues` must be unique.
  /// - Precondition: The sequence must not have duplicate keys.
  /// - Note: Differs from the initializer in the standard library, which doesn't allow labeled tuple elements.
  ///     This can't support *all* labels, but it does support `(key:value:)` specifically,
  ///     which `Dictionary` and `KeyValuePairs` use for their elements.
  @inlinable init(uniqueKeysWithValues keysAndValues: some Sequence<Element>) {
    self.init(uniqueKeysWithValues: keysAndValues.lazy.map(unlabeled))
  }

  // MARK: - Subscripts

  ///- Returns: nil if `key` is nil
  @inlinable subscript(optional key: Key?) -> Value? { key.flatMap { self[$0] } }

  /// Assign and return a `default` when the value for a key is `nil`.
  @inlinable subscript(
    key: Key,
    valueAddedIfNil value: @autoclosure() -> Value
  ) -> Value {
    mutating get {
      self[key]
      ?? { [value = value()] in
        self[key] = value
        return value
      } ()
    }
  }

  // MARK: - Methods

  /// Same values, corresponding to `map`ped keys.
  ///
  /// - Parameter transform: Accepts each key of the dictionary as its parameter
  ///   and returns a key for the new dictionary.
  /// - Postcondition: The collection of transformed keys must not contain duplicates.
  @inlinable func mapKeys<Transformed, Error>(
    _ transform: (Key) throws(Error) -> Transformed
  ) throws(Error) -> [Transformed: Value] {
    .init(
      uniqueKeysWithValues: try map { element throws(Error) in
        (try transform(element.key), element.value)
      }
    )
  }

  /// Same values, corresponding to `map`ped keys.
  ///
  /// - Parameters:
  ///   - transform: Accepts each key of the dictionary as its parameter
  ///     and returns a key for the new dictionary.
  ///   - combine: A closure that is called with the values for any duplicate
  ///     keys that are encountered. The closure returns the desired value for
  ///     the final dictionary.
  /// - Throws: `TransformError`, `CombineError`
  @inlinable func mapKeys<Transformed, TransformError, CombineError>(
    _ transform: (Key) throws(TransformError) -> Transformed,
    uniquingKeysWith combine: (Value, Value) throws(CombineError) -> Value
  ) rethrows -> [Transformed: Value] {
    try .init(
      map { (try transform($0.key), $0.value) },
      uniquingKeysWith: combine
    )
  }

  /// `compactMap`ped keys, with their values.
  ///
  /// - Parameter transform: Accepts each key of the dictionary as its parameter
  ///   and returns a potential key for the new dictionary.
  /// - Postcondition: The collection of transformed keys must not contain duplicates.
  @inlinable func compactMapKeys<Transformed, Error>(
    _ transform: (Key) throws(Error) -> Transformed?
  ) throws(Error) -> [Transformed: Value] {
    .init(
      uniqueKeysWithValues: try forceCastError(
        to: Error.self,
        compactMap { key, value in try transform(key).map { ($0, value) } }
      )
    )
  }

  /// Same keys, corresponding to `map`ped key-value pairs.
  ///
  /// - Parameter transform: Accepts each element of the dictionary as its parameter
  ///   and returns a transformed value.
  @inlinable func mapToValues<Transformed, Error>(
    _ transform: (Element) throws(Error) -> Transformed
  ) throws(Error) -> [Key: Transformed] {
    .init(uniqueKeysWithValues: zip(keys, try map(transform)))
  }

  /// `merge`, with labeled tuples.
  ///
  /// - Parameter pairs: Either `KeyValuePairs<Key, Value>`
  ///   or a `Sequence` with the same element type as that.
  @inlinable mutating func merge<Error>(
    _ pairs: some Sequence<Element>,
    uniquingKeysWith combine: (Value, Value) throws(Error) -> Value
  ) throws(Error) {
    try forceCastError(
      to: Error.self,
      merge(pairs.lazy.map(unlabeled), uniquingKeysWith: combine)
    )
  }
}

// MARK: - Value: Equatable
public extension DictionaryProtocol where Value: Equatable {
  /// The only key that maps to `value`.
  /// - Throws: `AnySequence<Element>.OnlyMatchError`
  /// - Bug: Cannot use typed error signature.
  @inlinable func onlyKey(for value: Value) throws -> Key {
    try forceCastError(
      to: AnySequence<Element>.OnlyMatchError.self,
      onlyMatch { $0.value == value } .key
    )
  }
}

// MARK: - Value: Sequence
public extension DictionaryProtocol where Value: Sequence {
  /// Flatten value sequences,
  /// pairing each value element with its original key.
  @inlinable func flatMap() -> some Sequence<(key: Key, value: Value.Element)> {
    lazy.flatMap { key, value in value.lazy.map { (key, $0) } }
  }
}

// MARK: - Key == Value
public extension DictionaryProtocol where Key == Value {
  /// The longest series of elements that will lead to `destination`.
  /// - Precondition: The elements represent a "`destination:source`" relationship.
  /// - Returns: `nil` if `destination` is not a key in this dictionary.
  @inlinable func path(to destination: Value) -> (some Sequence<Value>)? {
    self[destination].map { _ in
      sequence(first: destination) { self[$0] }.reversed()
    }
  }
}

// MARK: - Value == Int
public extension DictionaryProtocol where Value == Int {
  /// Create "buckets" from a sequence of keys,
  /// such as might be used for a histogram.
  /// - Note: This can be used for a "counted set".
  @inlinable init(bucketing unbucketedKeys: some Sequence<Key>) {
    self.init(zip(unbucketedKeys, constant: 1), uniquingKeysWith: +)
  }
  
  /// Treating this dictionary as a "counted set", reduce the element's value by 1.
  /// - Throws: If `countedSetElement` is not a key.
  @inlinable mutating func remove(countedSetElement: Key) throws {
    guard let count = self[countedSetElement] else { throw error }
    self[countedSetElement] = count == 1 ? nil : count - 1
  }
}

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

// MARK: -

/// Return an unmodified value when uniquing `Dictionary` keys.
public enum PickValue<Value> { }

public extension PickValue {
  /// Keep the original value.
  static var keep: (Value, Value) -> Value {
    { original, _ in original }
  }

  /// Overwrite the original value.
  static var overwrite: (Value, Value) -> Value {
    { $1 }
  }
}
