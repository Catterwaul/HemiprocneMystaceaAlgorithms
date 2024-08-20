import Algorithms

/// Prepend an element before a sequence.
@inlinable public func chain<Element>(
  _ element: Element,
  _ sequence: some Sequence<Element>
) -> some Sequence<Element> {
  chain(CollectionOfOne(element), sequence)
}

/// Append an element after a sequence.
@inlinable public func chain<Element>(
  _ sequence: some Sequence<Element>,
  _ element: Element
) -> some Sequence<Element> {
  chain(sequence, CollectionOfOne(element))
}

/// Chain one sequence after another, without duplicating the potentially overlapping portion in the middle.
@inlinable public func chainWithoutOverlap<Element: Equatable>(
  _ sequence1: some Sequence<Element>, _ sequence2: some Sequence<Element>
) -> some Sequence<Element> {
  chain(
    sequence1.withDropIterators.lazy
      .prefix { !sequence2.starts(with: IteratorSequence($0.iterator)) }
      .map(\.element),
    sequence2
  )
}
