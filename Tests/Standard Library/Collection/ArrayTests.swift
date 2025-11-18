import typealias Cast.CastError
import HMAlgorithms
import Testing

struct ArrayTests {
  @Test func init_tuple() throws {
    #expect(
      try Array(mirrorChildValuesOf: (1, 2, 3, 4, 5)) == [1, 2, 3, 4, 5]
    )

    #expect(throws: CastError.self) {
      _ = try [Int](mirrorChildValuesOf: (1, 2, "3", 4, 5))
    }
  }
}
