import HMAlgorithms
import Testing

struct ZipTests {
  @Test func constant() {
    #expect(
      zip(1...3, constant: "🧛🏼")
        .elementsEqual([(1, "🧛🏼"), (2, "🧛🏼"), (3, "🧛🏼")], by: ==)
    )
  }

  @Test func pack() {
    let sequences = (
      1...5,
      ["🇨🇦", "🐝", "🌊"],
      stride(from: 20, through: 80, by: 20),
      AnyIterator { "😺" }
    )

    let zipped = zip(
      sequences.0,
      sequences.1,
      sequences.2,
      sequences.3
    )
    #expect(
      zipped.elementsEqual(
        [ (1, "🇨🇦", 20, "😺"),
          (2, "🐝", 40, "😺"),
          (3, "🌊", 60, "😺")
        ],
        by: ==
      )
    )
  }
}
