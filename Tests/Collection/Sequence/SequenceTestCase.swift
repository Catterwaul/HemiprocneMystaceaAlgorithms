import HMAlgorithms
import XCTest

final class SequenceTestCase: XCTestCase {
  // MARK:- Properties
  func test_pauseable() {
    range: do {
      let upperLimit = 5
      let pauseableRange = AnyIterator((1...upperLimit).makeIterator())

      _ = pauseableRange.next()
      for _ in pauseableRange.prefix(1) { }

      func doNothin(_: some Any) { }
      pauseableRange.prefix(1).forEach(doNothin)
      _ = pauseableRange.prefix(1).map(doNothin)

      XCTAssertEqual(
        Array(pauseableRange), Array(5...upperLimit)
      )
    }

    typealias Number = Int
    let pauseableFibonacciSequence = AnyIterator(Number.fibonacciSequence().makeIterator())

    func getNext(_ count: Int) -> [Number] {
      .init(pauseableFibonacciSequence.prefix(count))
    }

    XCTAssertEqual(getNext(10), [0, 1, 1, 2, 3, 5, 8, 13, 21, 34])
    XCTAssertEqual(getNext(10), [55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181])
  }

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

  func test_subscript_sorted() {
    XCTAssertEqual(
      Array(stride(from: 10, through: 100, by: 10)[sorted: [0, 2, 3, 7, 10, 20]]),
      [10, 30, 40, 80]
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

  func test_interleaved() {
    let oddsTo7 = stride(from: 1, to: 7, by: 2)
    let evensThrough10 = stride(from: 2, through: 10, by: 2)
    let oneThrough6 = Array(1...6)

    XCTAssertEqual(
      Array(oddsTo7.interleaved(with: evensThrough10)),
      oneThrough6
    )

    XCTAssertEqual(
      Array(
        oddsTo7.interleaved(with: evensThrough10, keepingLongerSuffix: true)
      ),
      oneThrough6 + [8, 10]
    )
  }

  func test_onlyMatch() {
    XCTAssertEqual(try (1...5).onlyMatch { $0 > 4 }, 5 )

    typealias Error = AnySequence<Int>.OnlyMatchError
    
    XCTAssertThrowsError( try (1...5).onlyMatch { $0 < 4 } ) { error in
      XCTAssert(Error.moreThanOneMatch ~= error)
    }

    XCTAssertThrowsError( try (1...5).onlyMatch { $0 < 1 } ) { error in
      XCTAssert(Error.noMatches ~= error)
    }
  }

  func test_prefixThroughFirst() {
    XCTAssertEqual(
      .init([1, 2, 3, 3, 5].prefixThroughFirst { $0 >= 3 }),
      [1, 2, 3]
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
	
  func test_sorted() {
    let structs = [(1, "A"), (2, "A"), (2, "B")].map(Struct.init)

    XCTAssertEqual(
      structs.sorted(orders: (.forward, .forward)) {
        ($0.string, $0.int % 2)
      },
      [(2, "A"), (1, "A"), (2, "B")].map(Struct.init)
    )

    XCTAssertEqual(
      structs.sorted(orders: (.forward, .reverse)) {
        ($0.string, $0.int % 2)
      },
      [(1, "A"), (2, "A"), (2, "B")].map(Struct.init)
    )

    XCTAssertEqual(
      structs.sorted(orders: (.reverse, .forward)) {
        ($0.string, $0.int % 2)
      },
      [(2, "B"), (2, "A"), (1, "A")].map(Struct.init)
    )

    XCTAssertEqual(
      structs.sorted(orders: (.reverse, .reverse)) {
        ($0.string, $0.int % 2)
      },
      [(2, "B"), (1, "A"), (2, "A"), ].map(Struct.init)
    )
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

  func test_windows() {
    XCTAssertEqual(
      .init(stride(from: 1, through: 5, by: 1).windows(ofCount: 3).map(Array.init)),
      [.init(1...3), .init(2...4), .init(3...5)]
    )
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
