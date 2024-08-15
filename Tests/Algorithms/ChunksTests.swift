import HMAlgorithms
import Testing

struct ChunksTests {
  @Test func chunks() {
    #expect(
      (1...6).chunks(totalCount: 3).map(Array.init)
      ==
      [[1, 2], [3, 4], [5, 6]]
    )

    #expect(
      (1...7).chunks(totalCount: 2).map(Array.init)
      ==
      [[1, 2, 3], [4, 5, 6, 7]]
    )
  }
}
