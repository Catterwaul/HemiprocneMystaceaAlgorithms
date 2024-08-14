import HMAlgorithms
import Testing

struct RangeExpressionTests {
  private let lowerBound = 1
  private let upperBound = 10
  private var range: Range<Int> { lowerBound..<upperBound }
  private var closedRange: ClosedRange<Int> { .init(range) }
  private var partialRangeFrom: PartialRangeFrom<Int> { lowerBound... }
  private var partialRangeUpTo: PartialRangeUpTo<Int> { ..<upperBound }
  private var partialRangeThrough: PartialRangeThrough<Int> { .init(partialRangeUpTo) }

  @Test func containsSelf() {
    #expect(closedRange.contains(closedRange))
    #expect(partialRangeFrom.contains(partialRangeFrom))
    #expect(partialRangeThrough.contains(partialRangeThrough))
    #expect(partialRangeUpTo.contains(partialRangeUpTo))
    #expect(range.contains(range))
  }

  @Test func containsClosedRange() {
    #expect(range.contains(closedRange))
    #expect(partialRangeFrom.contains(closedRange))
    #expect(partialRangeUpTo.contains(closedRange))
    #expect(partialRangeThrough.contains(closedRange))
  }

  @Test func containsRange() {
    #expect(closedRange.contains(range))
    #expect(partialRangeFrom.contains(range))
    #expect(partialRangeUpTo.contains(range))
    #expect(partialRangeThrough.contains(range))
  }

  @Test func partial() {
    #expect(partialRangeThrough.contains(partialRangeUpTo))
    #expect(partialRangeUpTo.contains(partialRangeThrough))
  }
}
