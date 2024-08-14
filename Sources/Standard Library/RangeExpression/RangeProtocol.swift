/// Additional requirements for all `RangeExpression`s.
public protocol RangeProtocol<Bound>: RangeExpression {
  /// Whether this range fully encompasses another.
  @inlinable func contains(_ range: Self) -> Bool

  /// Whether this range fully encompasses a closed range.
  @inlinable func contains(_ range: ClosedRange<Bound>) -> Bool
}

public extension RangeProtocol where Bound: Strideable, Bound.Stride: SignedInteger {
  /// Whether this range fully encompasses another.
  @inlinable func contains(_ range: Range<Bound>) -> Bool { contains(ClosedRange(range)) }
}

// MARK: - ClosedRange
extension ClosedRange: RangeProtocol {
  @inlinable public func contains(_ range: Self) -> Bool {
    contains(range.lowerBound) && contains(range.upperBound)
  }
}

// MARK: - PartialRangeFrom
extension PartialRangeFrom: RangeProtocol {
  @inlinable public func contains(_ range: Self) -> Bool { contains(range.lowerBound) }
  @inlinable public func contains(_ range: ClosedRange<Bound>) -> Bool { contains(range.lowerBound) }
}

// MARK: - PartialRangeThrough
extension PartialRangeThrough: RangeProtocol {
  @inlinable public func contains(_ range: Self) -> Bool { contains(range.upperBound) }
  @inlinable public func contains(_ range: ClosedRange<Bound>) -> Bool { contains(range.upperBound) }
}

// MARK: - PartialRangeUpTo
extension PartialRangeUpTo: RangeProtocol {
  @inlinable public func contains(_ range: Self) -> Bool { range.upperBound <= upperBound }
  @inlinable public func contains(_ range: ClosedRange<Bound>) -> Bool { contains(range.upperBound) }
}

// MARK: - Range
extension Range: RangeProtocol {
  @inlinable public func contains(_ range: Self) -> Bool { range.upperBound <= upperBound }
  @inlinable public func contains(_ range: ClosedRange<Bound>) -> Bool {
    contains(range.lowerBound) && contains(range.upperBound)
  }
}
