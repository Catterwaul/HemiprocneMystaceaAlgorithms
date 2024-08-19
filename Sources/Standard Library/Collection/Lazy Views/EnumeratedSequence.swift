public extension EnumeratedSequence {
  struct Error: Swift.Error {
    public let index: Int
    public let error: Swift.Error
  }

  func mapElements<Transformed, Error>(
    _ transform: (Base.Element) throws(Error) -> Transformed
  ) throws -> [Transformed] {
    try map { enumeratedElement throws(Self.Error) in
      do { return try transform(enumeratedElement.element) }
      catch { throw Self.Error(index: enumeratedElement.offset, error: error) }
    }
  }
}
