public extension SetAlgebra {
  /// - Throws: if `elements` contains any duplicates.
  @inlinable init(unique elements: some Sequence<Element>) throws {
    self = try elements.reduce(into: []) {
      guard $0.insert($1).inserted
      else { throw Error.DuplicateElement() }
    }
  }

  typealias Error = SetAlgebraError<Self>
}

/// A collection of error types for a `SetAlgebra` type.
public enum SetAlgebraError<Set: SetAlgebra> {
  /// Duplicate elements were supplied.
  public struct DuplicateElement: Error {
    @usableFromInline init() { }
  }
}
