import typealias Cast.Error
import HMAlgorithms
import Testing

struct ArrayTests {
  @Test func init_tuple() throws {
    #expect(
      try Array(mirrorChildValuesOf: (1, 2, 3, 4, 5)) == [1, 2, 3, 4, 5]
    )

    #expect(throws: Cast.Error.self) {
      _ = try [Int](mirrorChildValuesOf: (1, 2, "3", 4, 5))
    }
  }

  @Test func without() {
    let rabbitsAndEars = ["👯", "🐇", "🐰", "👂", "🌽"]

    #expect(
      rabbitsAndEars.without(prefix: ["🐰"]) == nil
    )

    #expect(
      rabbitsAndEars.without(prefix: ["👯", "🐇"])
      == ["🐰", "👂", "🌽"]
    )
  }
}
