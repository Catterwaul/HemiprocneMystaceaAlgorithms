import Algorithms

/// Thrown when `[validating:]` is called with an invalid index.
public struct IndexingError<Collection: Swift.Collection>: Error {
  @inlinable public init() { }
}

public extension Collection {
  // MARK: - Subscripts

  /// Subscript this collection with a sequence of indices.
  @inlinable subscript(indices: some Sequence<Index>) -> some Sequence<Element> {
    indices.lazy.map { self[$0] }
  }

  /// Subscript at an offset index.
  ///
  /// Useful for collections that don't use integer indices, like `String`.
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
}

public extension Collection where Element: Equatable {
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
