public extension AnyIterator {
  /// Process iterations with a closure.
  /// - Parameters:
  ///   - processNext: Executes with every iteration.
  init(
    _ sequence: some Sequence<Element>,
    processNext: @escaping (Element?) -> Void
  ) {
    self.init(
      Swift.sequence(state: sequence.makeIterator()) { iterator -> Element? in
        let next = iterator.next()
        processNext(next)
        return next
      }
    )
  }
}
