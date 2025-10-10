import Algorithms
import HMAlgorithms
import Testing

struct CollectionTests {
  // MARK: - Subscripts
  @available(macOS 15.0, *)
  @Test func subscript_indexSequence() {
    let stride = stride(from: 1, to: 4, by: 2)
    #expect(
      Array(["🐰", "🌞", "🎃", "🎅"][chain(stride, stride)])
      == ["🌞", "🎅", "🌞", "🎅"]
    )
  }

  @Test func subscript_startOffsetBy() {
    #expect("🎤🐈"[startIndexOffsetBy: 1] ==  "🐈")
  }

  @Test func subscript_validating() throws {
    #expect(throws: [String].IndexingError.self) {
      try ["🐾", "🥝"][validating: 2]
    }

    let collection = Array(1...10)
    #expect(try collection[validating: 0] == 1)
    #expect(throws: [Int].IndexingError.self) {
      try collection[validating: collection.endIndex]
    }
  }

  // MARK: - Methods
  @Test func lastNonNil() {
    let bidirectionalCollection: [() -> Int?] = [
      { fatalError("Execution should not reach this point because this is a BidirectionalCollection.") },
      { 1 },
      { nil }
    ]
    #expect(bidirectionalCollection.lastNonNil { $0() } == 1)

    sequence: do {
      #expect(
        stride(from: 1, through: 5, by: 1)
          .lastNonNil { Optional($0).filter { $0 <= 3 } }
        == 3
      )
    }
  }

  @Test func prefix() {
    #expect("glorb14prawn".prefix(upTo: "1") == "glorb")
    #expect("glorb14prawn".prefix(through: "1") == "glorb1")
    #expect("boogalawncare".prefix(upTo: "z") == nil)
    #expect("boogalawncare".prefix(through: "z") == nil)
  }

  @Test func rotated() {
    #expect(Array([0, 1, 2, 3].rotated(by: -1)) == [3, 0, 1, 2])
  }
}
