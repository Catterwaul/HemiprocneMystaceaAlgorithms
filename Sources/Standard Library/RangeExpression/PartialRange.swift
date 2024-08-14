// MARK: - PartialRangeThrough
public extension PartialRangeThrough where Bound: Strideable {
  /// - Note: This does not transform the range from *exclusive* to *inclusive*, regarding the upper bound.
  /// It is merely another way to represent the exact same range.
  @inlinable init(_ range: PartialRangeUpTo<Bound>) {
    self = ...range.upperBound.advanced(by: -1)
  }

  @inlinable func contains(_ range: PartialRangeUpTo<Bound>) -> Bool { contains(.init(range)) }
}

// MARK: - PartialRangeUpTo
public extension PartialRangeUpTo {
  @inlinable init(_ range: PartialRangeThrough<Bound>) {
    self = ..<range.upperBound
  }

  @inlinable func contains(_ range: PartialRangeThrough<Bound>) -> Bool { contains(.init(range)) }
}
