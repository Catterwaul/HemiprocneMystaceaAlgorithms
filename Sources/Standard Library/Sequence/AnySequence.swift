public extension AnySequence {
    /// An error thrown from a call to `onlyMatch`.
  enum OnlyMatchError: Error {
    case noMatches
    case moreThanOneMatch
  }
}
