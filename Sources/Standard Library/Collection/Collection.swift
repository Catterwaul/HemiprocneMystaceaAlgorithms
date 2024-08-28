import Algorithms

/// Thrown when `[validating:]` is called with an invalid index.
public struct IndexingError<Collection: Swift.Collection>: Error {
  @usableFromInline init() { }
}

public extension Collection {
  // MARK: - Subscripts

  /// Subscript this collection with a sequence of indices.
  @inlinable subscript(indices: some Sequence<Index>) -> some Sequence<Element> {
    indices.lazy.map { self[$0] }
  }

  /// - Complexity: O(`position`)
  @inlinable subscript(startIndexOffsetBy position: Int) -> Element {
    self[index(startIndex, offsetBy: position)]
  }

  typealias IndexingError = HMAlgorithms.IndexingError<Self>

  /// Ensure an index is valid before accessing an element of the collection.
  /// - Returns: The same as the unlabeled subscript, if an error is not thrown.
  /// - Throws: `IndexingError` if `indices` does not contain `index`.
  @inlinable subscript(validating index: Index) -> Element {
    get throws {
      guard indices.contains(index) else { throw IndexingError() }
      return self[index]
    }
  }

  // MARK: - Methods
  /// Remove the beginning or end of a `Collection`.
  /// - Parameters:
  ///   - adfix: A prefix or suffix.
  ///   - hasAdfix: Whether a collection is adfixed by `adfix`.
  ///   - drop: Create a `SubSequence` by removing `count` `Element`s.
  /// - Returns: `nil` if `hasAffix(affix)` is `false`.
  @inlinable func without<Adfix: Sequence<Element>>(
    adfix: Adfix,
    hasAdfix: (Adfix) -> Bool,
    drop: (_ count: Int) -> SubSequence
  ) -> SubSequence? {
    guard hasAdfix(adfix) else { return nil }

    return drop(adfix.count)
  }
}

public extension Collection where Element: Equatable {
  // MARK: - Methods

  ///- Returns: `nil` if `element` isn't present
  @inlinable func prefix(upTo element: Element) -> SubSequence? {
    firstIndex(of: element).map(prefix(upTo:))
  }

  ///- Returns: `nil` if `element` isn't present
  @inlinable func prefix(through element: Element) -> SubSequence? {
    firstIndex(of: element).map(prefix(through:))
  }
}

public extension Collection where SubSequence: RangeReplaceableCollection {
  /// The collection, rotated by an offset.
  @inlinable func rotated(by shift: Int) -> SubSequence {
    if shift >= 0 { dropFirst(shift) + prefix(shift) }
    else { suffix(-shift) + dropLast(-shift) }
  }
}
