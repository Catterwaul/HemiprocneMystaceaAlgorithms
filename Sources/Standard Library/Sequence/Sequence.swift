import enum Foundation.SortOrder
import Algorithms
import Cast
import Thrappture
import Tuplé

public extension Sequence {
  // MARK: - Properties
  /// - Complexity: O(n)
  @inlinable var count: Int { reduce(0) { count, _ in count + 1 } }
  
  /// Whether the sequence iterates exactly zero elements.
  @inlinable var isEmpty: Bool { first == nil }
  
  /// The first element of the sequence.
  /// - Returns: `nil` if the sequence is empty.
  @inlinable var first: Element? {
    var iterator = makeIterator()
    return iterator.next()
  }
  
  /// The last element of the sequence.
  /// - Precondition: The sequence is finite.
  /// - Returns: `nil` if the sequence is empty.
  /// - Complexity: O(n)
  @inlinable var last: Element? { reduce { $1 } }

  // MARK: - Methods
  
  /// The minimum element in the sequence, using a comparison closure.
  /// - Parameter comparable: A closure returning a comparable value to compare, for each element.
  /// More often than not, a key path.
  /// - Returns: `nil` if the sequence is empty.
  @inlinable func min<Error>(
    by comparable: (Element) throws(Error) -> some Comparable
  ) throws(Error) -> Element? {
    try forceCastError(
      to: Error.self,
      self.min { try comparable($0) < comparable($1) }
    )
  }

  /// - Returns: `min` for the elements with non-nil `comparable`s.
  @inlinable func min<Error>(
    by comparable: (Element) throws(Error) -> (some Comparable)?
  ) throws(Error) -> Element? {
    try compacted(by: comparable).min(by: \.unwrapped)?.element
  }

  /// The maximum element in the sequence, using a comparison closure.
  /// - Parameter comparable: A closure returning a comparable value to compare, for each element.
  /// More often than not, a key path.
  /// - Returns: `nil` if the sequence is empty.
  @inlinable func max<Error>(
    by comparable: (Element) throws(Error) -> some Comparable
  ) throws(Error) -> Element? {
    try forceCastError(
      to: Error.self,
      self.max { try comparable($0) < comparable($1) }
    )
  }

  /// - Returns: `max` for the elements with non-nil `comparable`s.
  @inlinable func max<Error>(
    by comparable: (Element) throws(Error) -> (some Comparable)?
  ) throws(Error) -> Element? {
    try compacted(by: comparable).max(by: \.unwrapped)?.element
  }

  // MARK: -
  
  /// A `Collection` of all non-nil elements whose `optional`s are also non-nil.
  /// - Parameter optional: Transforms an `Element` into an `Optional`.
  /// - Returns: A `Collection` of tuples of non-nil elements with their `optional`s unwrapped.
  @inlinable func compacted<Error, Wrapped>(
    by optional: (Element) throws(Error) -> Wrapped?
  ) throws(Error) -> some Collection<(element: Element, unwrapped: Wrapped)> {
    try lazy.map { element throws(Error) in
      try optional(element).map { (element, $0) }
    }.compacted()
  }

  /// Like `prefix(while:)`, but including one more element.
  @inlinable func prefixThroughFirst(
    where predicate: @escaping (Element) -> Bool
  ) -> some Sequence<Element> {
    sequence(state: (iterator: makeIterator(), finished: false)) {
      guard
        !$0.finished,
        let next = $0.iterator.next()
      else { return nil }
      
      if predicate(next) { $0.finished = true }
      return next
    }
  }
  
  /// - Returns: `nil` If the sequence has no elements, instead of an "initial result".
  @inlinable func reduce<Error>(
    _ nextPartialResult: (Element, Element) throws(Error) -> Element
  ) throws(Error) -> Element? {
    var iterator = makeIterator()
    return try iterator.next().map { first throws(Error) in
      try forceCastError(
        to: Error.self,
        IteratorSequence(iterator).reduce(first, nextPartialResult)
      )
    }
  }

  // MARK: -
  /// Distribute the elements as uniformly as possible, as if dealing one-by-one into shares.
  /// - Note: Later shares will be one smaller if the element count is not a multiple of `shareCount`.
  @inlinable func distributedUniformly(shareCount: Int)
  -> some Sequence<[Element]> & LazySequenceProtocol {
    (0..<shareCount).lazy.map {
      .init(dropFirst($0).striding(by: shareCount))
    }
  }

  // MARK: -
  /// Sorted by a common `Comparable` value.
  /// - Parameter comparable: A closure returning a comparable value to compare, for each element.
  /// More often than not, a key path.
  @inlinable func sorted<each Comparable: Swift.Comparable, Error>(
    by comparable: (Element) throws(Error) -> (repeat each Comparable)
  ) throws(Error) -> [Element] {
    try forceCastError(
      to: Error.self,
      try sorted { try (repeat each comparable($0)) < (repeat each comparable($1)) }
    )
  }

  /// Whether the elements of this sequence are sorted by common `Comparable` values.
  /// - Parameter comparable: A closure returning a comparable value to compare, for each element.
  /// More often than not, a key path.
  @inlinable func isSorted<each Comparable: Swift.Comparable, Error>(
    by comparable: (Element) throws(Error) -> (repeat each Comparable)
  ) throws(Error) -> Bool {
    try forceCastError(
      to: Error.self,
      try adjacentPairs().allSatisfy {
        try (repeat each comparable($0)) <= (repeat each comparable($1))
      }
    )
  }
}

/// An infinite sequence of a single value.
@inlinable public func sequence<Element>(_ element: Element) -> some Sequence<Element> {
  sequence(first: element, next: \.self)
}
