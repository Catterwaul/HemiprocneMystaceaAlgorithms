public extension Equatable where Self: AnyObject {
  /// Use default object comparison for equality.
  ///
  /// - Note: You still need to manually adopt `Equatable`,
  /// to use this for your reference types.
  static func == (class0: Self, class1: Self) -> Bool {
    class0 === class1
  }
}
