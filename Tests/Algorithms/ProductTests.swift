import HMAlgorithms
import Testing

struct ProductTests {
  @Test func _product4() {
    #expect(
      product4(0...1, "🅰️🐝", [false, true], [0.0, 1.0]).map(Struct.init)
      == Struct.cartesianProduct
    )
  }

  @Test func _product() {
    #expect(
      Set(product(0...1, "🅰️🐝", [], [0.0, 1.0]).map(Struct.init)).isEmpty
    )
    #expect(
      Set(product(0...1, "🅰️🐝", [false, true], [0.0, 1.0]).map(Struct.init))
      == .init(Struct.cartesianProduct)
    )
  }
}

private struct Struct: Hashable {
  let int: Int
  let character: Character
  let bool: Bool
  let double: Double
}

extension Struct {
  static var cartesianProduct: [Self] {
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
  }
}
