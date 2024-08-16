import typealias Tuplé.Vectuple2

public extension Sequence where Element: AdditiveArithmetic {
  /// - Complexity: O(n)
  /// - Returns: `nil` is the sequence is empty.
  var sum: Element? { reduce(+) }
}

public extension Sequence {
  /// The signed area of a 2D graph.
  /// - Precondition: This sequence is sorted by its **`x`** values.
  /// - Note: This should be a property but the necessary constraints can only be applied to a method.
  func definiteIntegral<Scalar: FloatingPoint>() -> Scalar?
  where Element == SIMD2<Scalar> {
    guard !isEmpty else { return nil }

    return adjacentPairs().reduce(0 as Scalar) { definiteIntegral, points in
      let delta = points.1 - points.0

      // [0]: rectangle continuing from previous `y`
      // [1]: right triangle with hypotenuse between old and new `y`s
      let areas = delta.x * [points.0.y, delta.y / 2] as SIMD2

      return definiteIntegral + areas[0] + areas[1]
    }
  }

  /// The signed area of a 2D graph.
  /// - Precondition: This sequence is sorted by its **`x`** values.
  /// - Note: This should be a property but the necessary constraints can only be applied to a method.
  func definiteIntegral<Scalar: FloatingPoint & SIMDScalar>() -> Scalar?
  where Element == Vectuple2<Scalar> {
    lazy.map(SIMD2.init(_:_:)).definiteIntegral()
  }
}
