import HMAlgorithms
import Testing

struct ProductTests {
  @Test func product4() {
    struct Struct: Equatable {
      let int: Int
      let character: Character
      let bool: Bool
      let double: Double
    }

    #expect(
      product(0...1, "🅰️🐝", [false, true], [0.0, 1.0]).map(Struct.init)
      ==
      [ .init(int: 0, character: "🅰️", bool: false, double: 0),
        .init(int: 0, character: "🅰️", bool: false, double: 1),
        .init(int: 0, character: "🅰️", bool: true, double: 0),
        .init(int: 0, character: "🅰️", bool: true, double: 1),
        .init(int: 0, character: "🐝", bool: false, double: 0),
        .init(int: 0, character: "🐝", bool: false, double: 1),
        .init(int: 0, character: "🐝", bool: true, double: 0),
        .init(int: 0, character: "🐝", bool: true, double: 1),
        .init(int: 1, character: "🅰️", bool: false, double: 0),
        .init(int: 1, character: "🅰️", bool: false, double: 1),
        .init(int: 1, character: "🅰️", bool: true, double: 0),
        .init(int: 1, character: "🅰️", bool: true, double: 1),
        .init(int: 1, character: "🐝", bool: false, double: 0),
        .init(int: 1, character: "🐝", bool: false, double: 1),
        .init(int: 1, character: "🐝", bool: true, double: 0),
        .init(int: 1, character: "🐝", bool: true, double: 1),
      ]
    )
  }
}
