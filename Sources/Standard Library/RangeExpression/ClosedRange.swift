/// - Remark: option+
infix operator ±: AdditionPrecedence

public extension AdditiveArithmetic where Self: Comparable {
  /// `bound - range...bound + range`
  /// - Remark: option+
  static func ± (bound: Self, range: Self) -> ClosedRange<Self> {
    bound - range...bound + range
  }
}
