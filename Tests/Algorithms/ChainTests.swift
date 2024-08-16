import HMAlgorithms
import Testing

struct ChainTests {
  @Test func _chain() {
    #expect(
      chain("🔗" as Character, "⛓️").elementsEqual("🔗⛓️")
    )
  }
}
