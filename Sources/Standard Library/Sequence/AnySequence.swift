public extension AnySequence {
  /// An error thrown from a call to `onlyMatch`.
  enum OnlyMatchError: Error {
    case noMatches
    case moreThanOneMatch
  }
  /// Use when `AnySequence` is required / `AnyIterator` can't be used.
  /// - Parameter getNext: Executed as the `next` method of this sequence's iterator.
  init(_ getNext: @escaping () -> Element?) {
    self.init(Iterator(getNext))
  }
}
