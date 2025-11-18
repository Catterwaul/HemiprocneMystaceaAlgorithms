import Cast

public extension Array {
  // MARK: - Initializers

  /// Create an `Array` if `subject's` values are all of one type.
  /// - Note: Useful for converting tuples to `Array`s.
  init(mirrorChildValuesOf subject: some Any) throws(CastError) {
    self = try cast(Mirror(reflecting: subject).children.map(\.value))
  }
}
