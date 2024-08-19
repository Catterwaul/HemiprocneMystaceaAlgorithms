import Cast

public extension Sequence {
  /// `reduce`, disregarding all sequence elements.
  @inlinable func reduce<Result, Error>(
    _ initialResult: Result,
    _ nextPartialResult: (_ partialResult: Result) throws(Error) -> Result
  ) throws(Error) -> Result {
    try forceCastError(
      to: Error.self,
      try reduce(initialResult) { partialResult, _ in
        try nextPartialResult(partialResult)
      }
    )
  }

  /// `reduce(into:)`, disregarding all sequence elements.
  @inlinable func reduce<Result, Error>(
    into initialResult: Result,
    _ updateAccumulatingResult: (_ partialResult: inout Result) throws(Error) -> Void
  ) throws(Error) -> Result {
    try forceCastError(
      to: Error.self,
      try reduce(into: initialResult) { partialResult, _ in
        try updateAccumulatingResult(&partialResult)
      }
    )
  }
  /// Accumulates transformed elements.
  /// - Returns: `nil`  if the sequence has no elements.
  @inlinable func reduce<Result>(
    _ transform: (Element) throws -> Result,
    _ getNextPartialResult: (Result, Result) throws -> Result
  ) rethrows -> Result? {
    try lazy.map(transform).reduce(getNextPartialResult)
  }
}
