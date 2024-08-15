import HMAlgorithms
import Testing

struct ChainTests {
  @Test func test_chain() {
    #expect(
      chain("🔗" as Character, "⛓️").elementsEqual("🔗⛓️")
    )
  }
}
