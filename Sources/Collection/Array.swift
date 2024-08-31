import Cast

public extension Array {
  // MARK: - Initializers

  /// Create an `Array` if `subject's` values are all of one type.
  /// - Note: Useful for converting tuples to `Array`s.
  init(mirrorChildValuesOf subject: some Any) throws(Cast.Error) {
    self = try cast(Mirror(reflecting: subject).children.map(\.value))
  }

  /// A hack to deal with `Sequence.next` not being allowed to `throw`.
  /// - Parameters:
  ///   - initialState: Mutable state.
  ///   - continuing: Check the state to see if iteration is complete.
  ///   - iterate: Mutates the state and returns an `Element`, or `throw`s.
  init<State>(
    initialState: State,
    while continuing: @escaping (State) -> Bool,
    iterate: (inout State) throws -> Element
  ) throws {
    var state = initialState
    self = try
    `while` { continuing(state) }
      .map { try iterate(&state) }
  }
}

// MARK: - Equatable
public extension Array where Element: Equatable {
  ///- Returns: `nil` if not prefixed with `prefix`.
  func without(prefix: some Sequence<Element>) -> Self? {
    without(adfix: prefix, hasAdfix: starts, drop: dropFirst)
      .map(Self.init)
  }
}
