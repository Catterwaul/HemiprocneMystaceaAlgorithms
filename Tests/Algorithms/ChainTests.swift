import HMAlgorithms
import Testing

struct ChainTests {
  @Test func _chain() {
    #expect(
      chain("🔗" as Character, "⛓️").elementsEqual("🔗⛓️")
    )
  }

  @Test func _chainWithoutOverlap() {
    #expect(
      chainWithoutOverlap(
        stride(from: 1, to: 10, by: 2),
        (5...15).filter { !$0.isMultiple(of: 2) }
      )
      .elementsEqual(stride(from: 1, through: 15, by: 2))
    )
  }
}
