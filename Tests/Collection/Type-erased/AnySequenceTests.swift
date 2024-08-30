import HMAlgorithms
import Testing

struct AnySequenceTests {
  @Test func init_getNext() {
    #expect(
      AnySequence { "🧞" }.prefix(3).joined() == "🧞🧞🧞"
    )
  }
}
