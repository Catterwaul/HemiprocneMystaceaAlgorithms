public extension KeyValuePairs where Key: Sendable {
  /// An error throw from trying to access a value for a key.
  enum AccessError: Error {
    case noValue(key: Key)
    case typeCastFailure(key: Key)
  }
}
