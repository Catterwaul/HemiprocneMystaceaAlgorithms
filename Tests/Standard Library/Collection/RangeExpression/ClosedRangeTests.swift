import HMAlgorithms
import Testing

struct ClosedRangeTests {
  @Test func minusToPlus() {
    #expect(2 ± 3 == -1...5)
  }
}
