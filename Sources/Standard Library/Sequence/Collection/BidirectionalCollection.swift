import Algorithms
import HMError

public extension BidirectionalCollection {
  /// Returns the last non-`nil` result obtained from applying the given
  /// transformation to the elements of the sequence.
  ///
  /// - Returns: The last non-`nil` return value of the transformation, or
  ///   `nil` if no transformation is successful.
  ///
  /// - Complexity: O(*n*). Every element must be tested.
  @inlinable func lastNonNil<Result, Error>(
    _ transform: (Element) throws(Error) -> Result?
  ) throws(Error) -> Result? {
    try reversed().firstNonNil(transform) ¿! Error.self
  }
}
