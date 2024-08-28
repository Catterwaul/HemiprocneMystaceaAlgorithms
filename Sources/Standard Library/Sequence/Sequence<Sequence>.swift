import Algorithms

public extension Sequence where Element: Sequence {
  var combinations: [[Element.Element]] {
    guard let initialResult = (first?.map { [$0] })
    else { return [] }

    return dropFirst().reduce(initialResult) { combinations, iteration in
      combinations.flatMap { combination in
        iteration.map { combination + [$0] }
      }
    }
  }
}
