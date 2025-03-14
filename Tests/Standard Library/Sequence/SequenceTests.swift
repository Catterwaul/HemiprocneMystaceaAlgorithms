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
  
  @Test func first_last() {
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
        .elementsEqual([[1, 4, 7, 10], [2, 5, 8], [3, 6, 9]])
    )
  }

  @Test func interspersed() {
    let oddsTo7 = stride(from: 1, to: 7, by: 2)
    let evensThrough10 = stride(from: 2, through: 10, by: 2)
    let oneThrough6 = Array(1...6)

    #expect(
      Array(oddsTo7.interspersed(with: evensThrough10))
      == oneThrough6
    )

    #expect(
      Array(
        oddsTo7.interspersed(with: evensThrough10, keepingLongerSuffix: true)
      ) == oneThrough6 + [8, 10]
    )
  }

  @Test func max_and_min() {
    let dictionary = ["1️⃣": 1, "🔟": 10, "💯": 100]
    #expect(dictionary.min(by: \.value)?.key == "1️⃣")
    #expect(dictionary.max(by: \.value)?.key == "💯")
  }

  @Test func max_and_min_withOptionals() {
    let catNames = [
      nil, "Frisky", nil, "Fluffy", nil,
      nil, "Gobo", nil,
      nil, "Mousse", nil, "Ozma", nil
    ]

    #expect(catNames.min(by: \.self) == "Fluffy")
    #expect(catNames.max(by: \.self) == "Ozma")
  }

  @Test func prefixThroughFirst() {
    #expect(
      .init([1, 2, 3, 3, 5].prefixThroughFirst { $0 >= 3 })
      == [1, 2, 3]
    )
  }

  @Test func reduce() {
    let sequence = [1, 2, 3, 4]
    #expect(sequence.reductions(+) == [1, 3, 6, 10])
    #expect(sequence.reduce(+) == 10)

    #expect(EmptyCollection<Int>().reductions(+) == [])
    #expect(EmptyCollection<Int>().reduce(+) == nil)
  }

  @Test func test_shifted() {
    let shifted = stride(from: 0, through: 3, by: 1).rotated(by: 1)
    #expect(Array(shifted) == [1, 2, 3, 0])
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

    let unsorted = [3, 0, 1, 2, -1]
    let sorted = Array(-1...3)
    #expect(try unsorted.sorted(by: \.self) == sorted)
    #expect(unsorted.sorted(by: \.self, >) == sorted.reversed())

    let unsortedTuples = [(1, 1), (0, 1), (1, 0), (0, 0)]
    let sortedTuples = [(0, 1), (0, 0), (1, 1), (1, 0)]
    #expect(try unsortedTuples.sorted(by: \.self, (<, >)).elementsEqual(sortedTuples, by: ==))
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
    let isSorted = chain.isSorted(by: \.comparable)
    #expect(isSorted)
  }
}
