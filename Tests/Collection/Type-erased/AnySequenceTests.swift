import HMAlgorithms
import Testing

struct AnySequenceTests {
  @Test func init_getNext() {
    #expect(
      AnySequence { "🧞" }.prefix(3).joined() == "🧞🧞🧞"
    )
  }

  @Test func init_zip() {
    let sequences = (
      1...5,
      ["🇨🇦", "🐝", "🌊"],
      stride(from: 20, through: 80, by: 20),
      AnyIterator { "😺" }
    )

    #expect(
      AnySequence.zip(sequences.0, sequences.1)
      ==
      [(1, "🇨🇦"), (2, "🐝"), (3, "🌊"), (4, nil), (5, nil)] as [(Int?, String?)]
    )
  }
}
