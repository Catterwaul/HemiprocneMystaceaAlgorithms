import HMAlgorithms
import Testing
import Thrappture

struct SequenceTests {
  // MARK: - Properties
  @Test func count() {
    #expect(stride(from: 0, to: 10, by: 2).count == 5)
  }
  
  @Test func isEmpty() {
    #expect(stride(from: 1, to: 1, by: 1).isEmpty)
    #expect(!stride(from: 1, through: 1, by: 1).isEmpty)
  }
  
  @Test func first_last() throws {
    let odds = stride(from: 1, through: 10, by: 2)
    #expect(odds.first == 1)
    #expect(odds.prefix(0).first == nil)
    #expect(odds.last == 9)
    #expect(odds.prefix(0).last == nil)
  }
  
  // MARK: - Methods
  @Test func distributedUniformly() {
    #expect(
      (1...10).distributedUniformly(shareCount: 3)
      == [[1, 4, 7, 10], [2, 5, 8], [3, 6, 9]]
    )
  }

  @Test func max_and_min() {
    let dictionary = ["1️⃣": 1, "🔟": 10, "💯": 100]
    #expect(dictionary.min(by: \.value)?.key == "1️⃣")
    #expect(dictionary.max(by: \.value)?.key == "💯")
  }

  @Test func prefixThroughFirst() {
    #expect(
      .init([1, 2, 3, 3, 5].prefixThroughFirst { $0 >= 3 })
      == [1, 2, 3]
    )
  }

  @Test func sorted() {
    struct TypeWith1EquatableProperty: Equatable {
      let int: Int
    }

    #expect(
      [3, 0, 1, 2, -1]
        .map(TypeWith1EquatableProperty.init)
        .sorted(by: \.int)
      == (-1...3).map(TypeWith1EquatableProperty.init)
    )

    #expect(
      [(1, 2), (1, 1)].sorted(by: \.self).elementsEqual([(1, 1), (1, 2)], by: ==)
    )
  }

  @Test func isSorted() {
    struct TypeWithComparable {
      let comparable: Int
    }

    let random = Int.random(in: 1...(.max))
    let stride =
      stride(from: -random, through: random, by: random)
        .lazy.map(TypeWithComparable.init)
    let chain = chain(.init(comparable: -random), stride)
    #expect(chain.isSorted(by: \.comparable))
  }
}
