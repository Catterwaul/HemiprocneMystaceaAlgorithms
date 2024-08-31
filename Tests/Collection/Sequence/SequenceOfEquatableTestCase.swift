import HMAlgorithms
import XCTest

final class SequenceOfEquatableTestCase: XCTestCase {
  func test_contains() {
    XCTAssert(
      stride(from: -1, through: 1, by: 1).contains([-1, 0, 1])
    )

    XCTAssert(
      stride(from: -1, to: 10, by: 1).contains([2, 3, 4])
    )

    XCTAssertFalse(
      stride(from: -1, to: 10, by: 1).contains([2, 4])
    )

    XCTAssertFalse(
      stride(from: 2, to: 4, by: 1).contains((-1...5))
    )

    XCTAssert(
      stride(from: -1, to: 10, by: 1).contains(EmptyCollection())
    )
  }
  
  func test_containsOnlyUniqueValues() {
    XCTAssert((1...5).containsOnlyUniqueElements)
    XCTAssertFalse(["👯", "👯"].containsOnlyUniqueElements)
  }

  func test_isOrderedSuperset() {
    XCTAssert([-10, 1, 2, 5, 2, 3, 0, 4, 6, 9, 5, 4].isOrderedSuperset(of: 1...5))
    XCTAssert("🐱🐱".isOrderedSuperset(of: "🐱🐱"))
    XCTAssertFalse("🦎🧙🏽‍♂️".isOrderedSuperset(of: "🧙🏽‍♂️🦎"))
    XCTAssertFalse(
      CollectionOfOne(true).isOrderedSuperset(of: [true, false])
    )
  }

  func test_duplicates() {
    XCTAssertEqual(
      .init("💞❤️‍🔥💝❤️‍🔥🫀💕💔❤️‍🔥💕💝💘".duplicates),
      "❤️‍🔥💝💕"
    )
  }

  func test_map() {
    XCTAssertEqual(
      Array(["98", "99", "💯", "101"].mapUntilNil(Int.init)),
      [98, 99]
    )
  }

  func test_uniqueElements() {
    XCTAssertEqual(
      "💞❤️‍🔥💝❤️‍🔥🫀💕💔❤️‍🔥💕💝💘".uniqueElements.first,
      "💞"
    )
  }

  func test_elementsAreAllEqual() {
    XCTAssertNil([Bool]().elementsAreAllEqual)
    XCTAssert([1].elementsAreAllEqual == true)
    XCTAssert(["⭐️", "⭐️"].elementsAreAllEqual == true)
  }

  func test_uniqued_Equatable() {
    struct TypeWith1EquatableProperty: Equatable {
      let int: Int
    }

    let uniqueArray =
      [1, 1, 2, 4, 2, 3, 4]
        .map(TypeWith1EquatableProperty.init)
        .uniqued
    XCTAssertEqual(
      uniqueArray,
      [1, 2, 4, 3].map(TypeWith1EquatableProperty.init)
    )
  }
}
