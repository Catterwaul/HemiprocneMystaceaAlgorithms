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

  @Test func subscript_modulo() {
    let ints = [1, 2]
    for (index, int) in [
      (0, 1), (1, 2),
      (2, 1), (3, 2),
      (-1, 2), (-2, 1),
      (-3, 2), (-4, 1)
    ] {
      XCTAssertEqual(ints[cycling: index], int)
    }

    XCTAssertEqual(
      "abc"["c", moduloOffset: 1],
      "a"
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
  @Test func prefix() {
    #expect("glorb14prawn".prefix(upTo: "1") == "glorb")
    #expect("glorb14prawn".prefix(through: "1") == "glorb1")
    #expect("boogalawncare".prefix(upTo: "z") == nil)
    #expect("boogalawncare".prefix(through: "z") == nil)
  }

  @Test func rotated() {
    #expect(Array([0, 1, 2, 3].rotated(by: -1)) == [3, 0, 1, 2])
  }

  @available(
    swift, deprecated: 6,
    message: "Won't compile without the `shifted` constant"
  )
  @Test func shifted() {
    let shifted = stride(from: 0, through: 3, by: 1).shifted(by: 1)
    XCTAssertEqual(
      Array(shifted),
      [1, 2, 3, 0]
    )

    XCTAssertEqual(
      Array([0, 1, 2, 3].shifted(by: -1)),
      [3, 0, 1, 2]
    )
  }
}
