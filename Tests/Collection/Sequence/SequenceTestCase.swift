import HMAlgorithms
import XCTest

final class SequenceTestCase: XCTestCase {
  // MARK: - Properties
  func test_removingDuplicates() {
    XCTAssertEqual(
      String("⛲️⛲️⛲️🥐🥐⛲️⛲️⛲️⛲️🥐🥐🥐".removingDuplicates),
      "⛲️🥐⛲️🥐"
    )
  }

// MARK: - Subscripts

  func test_subscript_maxArrayCount() {
    XCTAssertEqual(
      Array(
        (1...6)[maxArrayCount: 2]
      ),
      [[1, 2], [3, 4], [5, 6]]
    )

    XCTAssertEqual(
      Array(
        stride(from: 1, through: 3, by: 0.5)[maxArrayCount: 2]
      ),
      [[1, 1.5], [2, 2.5], [3]]
    )

    XCTAssertEqual(
      Array(
        (1...2)[maxArrayCount: 10]
      ),
      [[1, 2]]
    )
  }

// MARK: - Methods

  func test_containsOnly() {
    XCTAssert(["🐯", "🐯"].containsOnly("🐯"))
  }

  func test_grouped() {
    XCTAssert(
      (0...4).grouped { $0 % 3 }
        .elementsEqual([(0, [0, 3]), (1, [1, 4]), (2, [2])], by: ==)
    )
  }

  func test_prefixThroughFirst() {
    XCTAssertEqual(
      .init([1, 2, 3, 3, 5].prefixThroughFirst { $0 >= 3 }),
      [1, 2, 3]
    )
  }

  func test_rangesOf() {
    XCTAssertEqual(
      [0, 1, .min, .min, 2, 2, .min, 3, 3, 3, .min, 4, 4, .min, 5]
        .ranges(for: [1, 2, 3, 4, 5]),
      [1...1, 4...5, 7...9, 11...12, 14...14]
    )
  }

  func test_isSorted() {
    struct TypeWithComparable {
      let comparable: Int
    }

    let random = Int.random(in: 1...(.max))
    let stride =
      stride(from: -random, through: random, by: random)
        .lazy.map(TypeWithComparable.init)
    let chain = chain(.init(comparable: -random), stride)
    XCTAssert(chain.isSorted(by: \.comparable))
    XCTAssert(chain.reversed().isSorted(by: \.comparable, >=))
  }

  func test_splitAndIncludeSeparators() {
    XCTAssertEqual(
      "¿What is your name? My name is 🐱, and I am a cat!"
        .split(separator: " ")
        .flatMap { $0.split(includingSeparators: \.isPunctuation) }
        .map(Array.init)
        .map { String($0) },
      [ "¿", "What", "is", "your", "name", "?",
        "My", "name", "is", "🐱", ",", "and", "I", "am", "a", "cat", "!"
      ]
    )
  }

  func test_uniqueMin() {
    XCTAssertEqual(try (1...10).uniqueMin(comparing: \.self).value, 1)

    XCTAssertThrowsError(
      try [1, 2, 1, 2, 3].uniqueMin(comparing: \.self)
    ) { error in
      guard case Extremum<Int>.UniqueError.notUnique(let extremum) = error 
      else { return XCTFail() }

      XCTAssertEqual(extremum.count, 2)
    }

    do {
      _ = try ([] as [Int]).uniqueMin(comparing: \.self)
    }
    catch Extremum<Int>.UniqueError.emptySequence { }
    catch { XCTFail() }
  }

  func test_root() {
    struct Struct {
      let property: Int

      var parent: Struct? {
        Optional(.init(property: property - 1))
          .filter { $0.property > 0 }
      }
    }

    XCTAssertEqual(
      root(Struct(property: 5), \.parent).property,
      1
    )
  }

  func test_recursive() {
    struct Struct {
      let array: [Struct]
    }

    let hierarchy = Struct(
      array: [
        .init(
          array: [
            .init(array: []),
            .init(array: [])
          ]
        ),
        .init(array: [])
      ]
    )

    XCTAssertEqual(
      recursive(hierarchy, \.array).count,
      5
    )
  }


  // MARK: - Element: Sequence

  func test_combinations() {
    XCTAssertEqual(
      [1...2, 3...4, 5...6].combinations,
      [ [1, 3, 5], [1, 3, 6],
        [1, 4, 5], [1, 4, 6],
        [2, 3, 5], [2, 3, 6],
        [2, 4, 5], [2, 4, 6]
      ]
    )
  }
}
