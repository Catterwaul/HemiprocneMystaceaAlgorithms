import enum Foundation.SortOrder
import Algorithms
import Cast
import Thrappture
import Tuplé

public extension Sequence {
  // MARK: - Properties
  /// An empty sequence, whose `Element` "would" match this type's.
  @inlinable static var empty: some Sequence<Element> {
    IteratorSequence(EmptyCollection.Iterator())
  }

  /// The iterators of all subsequences, incrementally dropping early elements.
  /// - Note: Begins with the iterator for the full sequence (dropping zero).
  @inlinable var dropIterators: some Sequence<Iterator> {
    withDropIterators.lazy.map(\.1)
  }

  /// Iterated normally, but after the iterator is exhausted: infinite `nil`s.
  @inlinable var padded: some Sequence<Element?> {
    sequence(state: makeIterator()) { $0.next() as Element?? }
  }

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

  /// Like `zip`ping with the iterators of all subsequences, incrementally dropping early elements.
  /// - Note: Begins with the iterator for the full sequence (dropping zero).
  @inlinable var withDropIterators: some Sequence<(element: Element, iterator: Iterator)> {
    sequence(state: makeIterator()) {
      let iterator = $0
      return $0.next().map { ($0, iterator) }
    }
  }
  
  // MARK: - Subscripts
  /// Splits a `Sequence` into equal "chunks".
  /// - Parameter maxArrayCount: The maximum number of elements in a chunk.
  /// - Returns: `Array`s with `maxArrayCount` `counts`,
  ///   until the last chunk, which may be smaller.
  subscript(maxArrayCount maxCount: Int) -> some Sequence<[Element]> {
    sequence(state: makeIterator()) { iterator in
      Optional(
        repeatElement((), count: maxCount).compactMap { iterator.next() }
      ).filter { !$0.isEmpty }
    }
  }

  /// - Precondition: The indices must be sorted, and non-negative.
  subscript(sorted indices: some Sequence<Int>) -> some Sequence<Element> {
    var iterator = makeIterator()
    return indices.differences.mapUntilNil {
      if case let skipCount = $0 - 1, skipCount > 0 {
        repeatElement((), count: skipCount).forEach { iterator.iterate() }
      }
      return iterator.next()
    }
  }

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

  private func getElement<Comparable: Swift.Comparable>(
    _ getComparable: (Element) throws -> Comparable?,
    _ getElement: ([(Comparable, Element)]) throws -> Element?
  ) rethrows -> Element? {
    let comparablesAndElements = try compactMap { element in
      try getComparable(element).map { comparable in (comparable, element) }
    }

    return try getElement(comparablesAndElements)
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
      sorted { try (repeat each comparable($0)) < (repeat each comparable($1)) }
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
      adjacentPairs().allSatisfy {
        try (repeat each comparable($0)) <= (repeat each comparable($1))
      }
    )
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

  /// A sequence made of sequences of elements that have potentially been combined.
  /// - Returns: An empty sequence if this sequence is itself empty.
  @inlinable func accumulated(
    _ accumulate: @escaping (Element, Element) -> Element?
  ) -> some Sequence<Element> {
    sequence(state: CurrentValueIterator(self)) { iterator in
      guard let accumulation = iterator.value else { return nil }

      return withoutActuallyEscaping({ iterator.next() }) { next in
        sequence(first: accumulation) { accumulation in
          next().flatMap { accumulate(accumulation, $0) }
        }.last
      }
    }
  }

  /// The elements of the sequence, with "duplicates" removed,
  /// based on a closure.
  @inlinable func uniqued(
    on getEquatable: (Element) throws -> some Equatable
  ) rethrows -> [Element] {
    try reduce(into: []) { uniqueElements, element in
      if zip(
        try uniqueElements.lazy.map(getEquatable),
        AnyIterator { [equatable = try getEquatable(element)] in equatable }
      ).allSatisfy(!=) {
        uniqueElements.append(element)
      }
    }
  }

  /// Group the elements by a transformation into a `Key`.
  /// - Note: Similar to `Dictionary(grouping values:)`,
  /// but preserves "key" ordering, and doesn't require hashability.
  @inlinable func grouped<Key: Equatable>(
    by key: (Element) throws -> Key
  ) rethrows -> [KeyValuePairs<Key, [Element]>.Element] {
    try reduce(into: []) {
      let key = try key($1)

      if let index = ($0.firstIndex { $0.key == key }) {
        $0[index].value.append($1)
      } else {
        $0.append((key, [$1]))
      }
    }
  }

  /// Alternates between the elements of two sequences.
  /// - Parameter keepSuffix:
  ///   When `true`, and the sequences have different lengths,
  ///   the suffix of `interspersed`  will be the suffix of the longer sequence.
  @inlinable func interspersed(
    with sequence: some Sequence<Element>,
    keepingLongerSuffix keepSuffix: Bool = false
  ) -> some Sequence<Element> {
    Swift.sequence(
      state: (
        AnyIterator(makeIterator()),
        AnyIterator(sequence.makeIterator())
      )
    ) { iterators in
      defer { iterators = (iterators.1, iterators.0) }
      return
        if let next = iterators.0.next() { next }
        else if keepSuffix { iterators.1.next() }
        else { nil }
    }
  }

  /// Transform this sequence until encountering a "`nil`".
  @inlinable func mapUntilNil<Transformed>(
    _ transform: @escaping (Element) -> Transformed?
  ) -> some Sequence<Transformed> {
    sequence(state: makeIterator()) {
      $0.next().flatMap(transform)
    }
  }

  /// The only match for a predicate.
  /// - Throws: `Error`, `AnySequence<Element>.OnlyMatchError`
  @inlinable func onlyMatch<Error>(
    for isMatch: (Element) throws(Error) -> Bool
  ) throws -> Element {
    typealias Error = AnySequence<Element>.OnlyMatchError
    guard let onlyMatch: Element = (
      try reduce(into: nil) { onlyMatch, element in
        switch (onlyMatch, try isMatch(element)) {
        case (_, false): break
        case (nil, true): onlyMatch = element
        case (.some, true): throw Error.moreThanOneMatch
        }
      }
    ) else { throw Error.noMatches }

    return onlyMatch
  }


  /// The elements of this sequence, and the ones after them.
  /// - Note: Every returned array will have the same count,
  /// so this stops short of the end of the sequence by `count - 1`.
  /// - Precondition: `count > 0`
  @inlinable func windows(ofCount count: Int) -> some Sequence<
    CompactedSequence<[Element?], Element>
  > {
    (0..<count).map(Array(self).dropFirst).transposed
  }

  /// - Parameters:
  ///   - comparable: The property to compare.
  ///   - areSorted: Whether the elements are in order, approaching the extremum.
  @inlinable func extremum<Comparable: Swift.Comparable>(
    comparing comparable: (Element) throws -> Comparable,
    areSorted: (Comparable, Comparable) throws -> Bool
  ) rethrows -> Extremum<Element>? {
    try first.map { first in
      try dropFirst().reduce(into: .init(value: first, count: 1)) {
        let comparables = (try comparable($0.value), try comparable($1))

        if try areSorted(comparables.0, comparables.1) {
          $0 = .init(value: $1, count: 1)
        } else if (comparables.0 == comparables.1) {
          $0.count += 1
        }
      }
    }
  }

  /// The only match for a predicate.
  /// - Throws: `AnySequence<Element>.OnlyMatchError`
  @inlinable func onlyMatch(for getIsMatch: (Element) throws -> Bool) throws -> Element {
    typealias Error = AnySequence<Element>.OnlyMatchError
    guard let onlyMatch: Element = (
      try reduce(into: nil) { onlyMatch, element in
        switch (onlyMatch, try getIsMatch(element)) {
        case (_, false):
          break
        case (nil, true):
          onlyMatch = element
        case (.some, true):
          throw Error.moreThanOneMatch
        }
      }
    ) else { throw Error.noMatches }

    return onlyMatch
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

  /// The collection, rotated by an offset.
  @inlinable func rotated(by shift: Int) -> any Sequence<Element> {
    if shift >= 0 { chain(dropFirst(shift), prefix(shift)) }
    else { chain(suffix(-shift), dropLast(-shift)) }
  }

  @inlinable func split(includingSeparators getIsSeparator: @escaping (Element) -> Bool)
  -> some Sequence< AnySequence<Element>.Spliteration > {
    var separatorFromPrefixIteration: Element?

    func process(next: Element?) -> Void {
      separatorFromPrefixIteration =
        next.map(getIsSeparator) == true
        ? next
        : nil
    }

    process(next: first)
    let prefixIterator = AnyIterator(
      dropFirst(
        separatorFromPrefixIteration == nil
        ? 0
        : 1
      ),
      processNext: process
    )

    return AnySequence {
      if let separator = separatorFromPrefixIteration {
        separatorFromPrefixIteration = nil
        return .separator(separator)
      }

      return
        Optional(
          prefixIterator.prefix { !getIsSeparator($0) }
        )
        .filter { !$0.isEmpty }
        .map(AnySequence.Spliteration.subSequence)
    }
  }
  
  /// - throws: `Extremum<Element>.UniqueError`
  @inlinable func uniqueMin(
    comparing comparable: (Element) throws -> some Comparable
  ) throws -> Extremum<Element> {
    typealias Error = Extremum<Element>.UniqueError

    guard let extremum = try extremum(comparing: comparable, areSorted: >)
    else { throw Error.emptySequence }

    guard extremum.count == 1
    else { throw Error.notUnique(extremum) }

    return extremum
  }

  /// Returns the accumulated result of combining the elements of the sequence using the given closure.
  /// - Parameter transform: A closure that combines the previously reduced
  ///   result and the next element in the receiving sequence.
  /// - Returns: `nil` If the sequence has no elements, instead of an "initial result".
  @inlinable func reduce<Error>(
    _ transform: (Element, Element) throws(Error) -> Element
  ) throws(Error) -> Element? {
    var iterator = makeIterator()
    return try iterator.next().map { first throws(Error) in
      try forceCastError(
        to: Error.self,
        IteratorSequence(iterator).reduce(first, transform)
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
  /// Sorted by a common `Comparable` value, and sorting closure.
  func sorted<Comparable: Swift.Comparable>(
    by comparable: (Element) throws -> Comparable,
    _ areInIncreasingOrder: (Comparable, Comparable) throws -> Bool
  ) rethrows -> [Element] {
    try sorted {
      try areInIncreasingOrder(comparable($0), comparable($1))
    }
  }

  /// Sorted by two common `Comparable` values.
  func sorted<Comparable0: Comparable, Comparable1: Comparable>(
    _ comparables: (Element) throws -> (Comparable0, Comparable1)
  ) rethrows -> [Element] {
    try sorted(comparables, <)
  }

  /// Sorted by two common `Comparable` values, and sorting closure.
  func sorted<Comparable0: Comparable, Comparable1: Comparable>(
    _ comparables: (Element) throws -> (Comparable0, Comparable1),
    _ areInIncreasingOrder: ((Comparable0, Comparable1), (Comparable0, Comparable1)) throws -> Bool
  ) rethrows -> [Element] {
    try sorted {
      try areInIncreasingOrder(comparables($0), comparables($1))
    }
  }

  func sorted<Comparable0: Comparable, Comparable1: Comparable>(
    orders: (SortOrder, SortOrder),
    _ comparables: (Element) throws -> (Comparable0, Comparable1)
  ) rethrows -> [Element] {
    try sorted {
      let comparables = try (comparables($0), comparables($1))
      switch orders {
      case (.forward, .forward):
        return comparables.0 < comparables.1
      case (.forward, .reverse):
        return (comparables.0.0, comparables.1.1) < (comparables.1.0, comparables.0.1)
      case (.reverse, .forward):
        return (comparables.1.0, comparables.0.1) < (comparables.0.0, comparables.1.1)
      case (.reverse, .reverse):
        return (comparables.1.0, comparables.1.1) < (comparables.0.0, comparables.0.1)
      }
    }
  }

  /// Whether the elements of this sequence are sorted by a common `Comparable` value.
  @inlinable func isSorted(
    by comparable: (Element) throws -> some Comparable
  ) rethrows -> Bool {
    try isSorted(by: comparable, <=)
  }

  /// Whether the elements of this sequence are sorted by a common `Comparable` value,
  /// and sorting closure.
  @inlinable func isSorted<Comparable: Swift.Comparable>(
    by comparable: (Element) throws -> Comparable,
    _ areInIncreasingOrder: (Comparable, Comparable) throws -> Bool
  ) rethrows -> Bool {
    try adjacentPairs().allSatisfy {
      try areInIncreasingOrder(comparable($0), comparable($1))
    }
  }
}

/// An infinite sequence of a single value.
@inlinable public func infiniteSequence<Element>(of element: Element) -> some Sequence<Element> {
  sequence(first: element, next: \.self)
}

/// A sequence of `Void`s that terminates when `predicate` returns `false`.
@inlinable public func `while`(_ predicate: @escaping () -> Bool) -> some Sequence<Void> {
  sequence(state: ()) {
    predicate() ? $0 : nil
  }
}

/// Recursively apply a transformation until it is no longer possible.
@inlinable public func root<T>(_ first: T, _ next: (T) -> T?) -> T {
  withoutActuallyEscaping(next) {
    sequence(first: first, next: $0).last!
  }
}

/// Recursively collect the elements of sequences.
@inlinable public func recursive<Root>(
  _ root: Root,
  _ children: (Root) -> some Sequence<Root>
) -> some Sequence<Root> {
  chain(
    root,
    children(root).flatMap { recursive($0, children) }
  )
}

public struct Extremum<Value: Sendable>: Sendable {
  public enum UniqueError: Swift.Error {
    case emptySequence
    case notUnique(Extremum)
  }

  public var value: Value
  public var count: Int

  @usableFromInline init(value: Value, count: Int) {
    self.value = value
    self.count = count
  }
}
