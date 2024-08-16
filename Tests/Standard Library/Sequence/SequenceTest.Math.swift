import typealias CoreGraphics.CGFloat
import HMAlgorithms
import Testing

extension SequenceTests {
  struct Math {
    @Test func sum() {
      #expect([1, 2, 3].sum == 6)
      #expect([0.5, 1, 1.5].sum == 3)
      #expect([CGFloat]().sum == nil)
    }

    @Test func definiteIntegral() {
      #expect(([] as [SIMD2<Double>]).definiteIntegral() == nil)

      let arrayWithZero = [(0.0, 0.0)]
      #expect(arrayWithZero.definiteIntegral() == 0)
      #expect((arrayWithZero + [(1, 1)]).definiteIntegral() == 0.5)

      #expect([(0.0, -3.0), (4, 1)].definiteIntegral() == -4)
    }
  }
}
