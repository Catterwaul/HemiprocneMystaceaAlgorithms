import Thrappture

/// `zip` a sequence with a single value, instead of another sequence.
@inlinable public func zip<Sequence: Swift.Sequence, Constant>(
  _ sequence: Sequence, constant: Constant
) -> some Swift.Sequence<(Sequence.Element, Constant)> {
  zip(sequence, infiniteSequence(of: constant))
}

/// `zip` any number of  sequences.
@inlinable public func zip<each Sequence: Swift.Sequence>(
  _ sequence: repeat each Sequence
) -> some Swift.Sequence<(repeat (each Sequence).Element)> {
  Swift.sequence(
    state: (repeat (each sequence).makeIterator())
  ) { iterator -> (repeat (each Sequence).Element)? in
    do {
      /// - Bug: [`Thrappture.mutateAndTransform` can't be used directly.](https://github.com/apple/swift/issues/74391)
      func mutateAndTransform<Iterator: IteratorProtocol>(
        _ iterator: Iterator
      ) throws -> (mutatedCopy: Iterator, transformed: Iterator.Element) {
        try HMAlgorithms.mutateAndTransform(iterator) { try $0.next().get() }
      }

      let iteratorAndNext = try (repeat mutateAndTransform(each iterator))
      iterator = (repeat (each iteratorAndNext).mutatedCopy)
      return (repeat (each iteratorAndNext).transformed)
    } catch {
      return nil
    }
  }
}

/// Get around the inability to mutate parameter packs.
///
/// This is ready to be made public in case it might come in handy elsewhere,
/// but we're not sure what else would need it.
@usableFromInline func mutateAndTransform<Value, Transformed, Error: Swift.Error>(
  _ value: Value,
  _ transform: (inout Value) throws(Error) -> Transformed
) throws(Error) -> (mutatedCopy: Value, transformed: Transformed) {
  var copy = value
  let transformed = try transform(&copy)
  return (copy, transformed)
}
