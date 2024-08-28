import Algorithms

public extension Sequence where Element: Sequence {
  var combinations: [[Element.Element]] {
    guard let initialResult = (first?.map { [$0] })
    else { return [] }

    return dropFirst().reduce(initialResult) { combinations, iteration in
      combinations.flatMap { combination in
        iteration.map { combination + [$0] }
      }
    }
  }

  /// Like `zip`, but with no limit to how many sequences are zipped.
  var transposed: some Sequence<
    CompactedSequence<[Element.Element?], Element.Element>
  > {
    sequence(state: map { $0.makeIterator() }) { iterators in
      iterators.indices.lazy.map { iterators[$0].next() }
        .compactedIfAllAreSome()
    }
  }
}
