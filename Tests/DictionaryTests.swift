import typealias Collections.OrderedDictionary
import Algorithms
import HMAlgorithms
import Testing

struct DictionaryTests {
  @Test func pickValue() {
    func test<Dictionary: DictionaryProtocol<String, String>>(_: Dictionary.Type) {
      let original = ["🗝": "🏰"]
      let overwriting = ["🗝": "✍️"]

      #expect(
        original.merging(overwriting, uniquingKeysWith: PickValue.keep)
        == original
      )

      #expect(
        original.merging(overwriting, uniquingKeysWith: PickValue.overwrite)
        == overwriting
      )
    }
    test(Dictionary.self)
    test(OrderedDictionary.self)
  }
  
  // MARK: - Initializers
  @Test func init_bucketing() {
    #expect(
      [Character: _](bucketing: "🗑⚱️🗑🦌🦌🗑🗑🦌⚱️")
      == ["⚱️": 2, "🗑": 4, "🦌": 3]
    )
  }

  @Test func init_uniqueKeysWithValues_KeyValuePairs() {
    func test<Dictionary: DictionaryProtocol<String, String> & Equatable>(_: Dictionary.Type) {
      #expect(
        Dictionary(
          uniqueKeysWithValues: ["🍐": "🪂", "👯‍♀️": "👯‍♂️"] as KeyValuePairs
        )
        == .init(
          uniqueKeysWithValues: [("🍐", "🪂"), ("👯‍♀️", "👯‍♂️")]
        )
      )
    }
    test(Dictionary.self)
    test(OrderedDictionary.self)
  }
  

  @Test(.disabled("Crashes. See https://github.com/apple/swift-corelibs-foundation/issues/76072"))
  func init_grouping_KeyValuePairs() {
    func test<Dictionary: DictionaryProtocol<String, [String]> & Equatable>(_: Dictionary.Type) {
      let dictionary = [
        "🔑": [ "🐅", "🐆", "🐈"],
        "🗝": ["🦖", "🦕"]
      ] as Dictionary

      #expect(
        Dictionary(
          grouping: [
            ("🔑", "🐅"), ("🔑", "🐆"), ("🔑", "🐈"),
            ("🗝", "🦖"), ("🗝", "🦕")
          ]
        ) == dictionary
      )

      #expect(
        Dictionary(
          grouping: [
            "🔑": "🐅", "🔑": "🐆", "🔑": "🐈",
            "🗝": "🦖", "🗝": "🦕"
          ] as KeyValuePairs
        ) == dictionary
      )
    }
    test(Dictionary.self)
    test(OrderedDictionary.self)
  }

  @Test func init_grouping_KeyValuePairs_Dictionary() {
    let dictionary = [
      "🔑": [ "🐅", "🐆", "🐈"],
      "🗝": ["🦖", "🦕"]
    ] as Dictionary

    #expect(
      Dictionary(
        grouping: [
          ("🔑", "🐅"), ("🔑", "🐆"), ("🔑", "🐈"),
          ("🗝", "🦖"), ("🗝", "🦕")
        ]
      ) == dictionary
    )

    #expect(
      Dictionary(
        grouping: [
          "🔑": "🐅", "🔑": "🐆", "🔑": "🐈",
          "🗝": "🦖", "🗝": "🦕"
        ] as KeyValuePairs
      ) == dictionary
    )
  }

  @Test func init_grouping_KeyValuePairs_OrderedDictionary() {
    let dictionary = [
      "🔑": [ "🐅", "🐆", "🐈"],
      "🗝": ["🦖", "🦕"]
    ] as OrderedDictionary

    #expect(
      OrderedDictionary(
        grouping: [
          ("🔑", "🐅"), ("🔑", "🐆"), ("🔑", "🐈"),
          ("🗝", "🦖"), ("🗝", "🦕")
        ]
      ) == dictionary
    )

    #expect(
      OrderedDictionary(
        grouping: [
          "🔑": "🐅", "🔑": "🐆", "🔑": "🐈",
          "🗝": "🦖", "🗝": "🦕"
        ] as KeyValuePairs
      ) == dictionary
    )
  }

// MARK: - Subscripts
  @Test func optionalKeySubscript() {
    func test<Dictionary: DictionaryProtocol<String, String>>(_: Dictionary.Type) {
      let dictionary = ["key": "value"] as Dictionary
      let key: String? = "key"
      let `nil`: String? = nil

      #expect(dictionary[optional: key] == "value")
      #expect(dictionary[optional: `nil`] == nil)
    }
    test(Dictionary.self)
    test(OrderedDictionary.self)
  }

  @Test func valueAddedIfNilSubscript() {
    func test<Dictionary: DictionaryProtocol<String, String> & Equatable>(_: Dictionary.Type) {
      var dictionary = ["key": "value"] as Dictionary
      let valyoo = "valyoo"
      #expect(
        dictionary[
          "kee",
          valueAddedIfNil: valyoo
        ] == valyoo
      )
      #expect(
        dictionary ==
        [ "key": "value",
          "kee": "valyoo"
        ]
      )
    }
    test(Dictionary.self)
    test(OrderedDictionary.self)
  }

  @Test func firstKeys() throws {
    func test<Dictionary: DictionaryProtocol<String, String> & Equatable>(_: Dictionary.Type) throws {
      #expect(
        try (["skunky": "monkey", "🦨": "🐒"] as Dictionary).onlyKey(for: "🐒")
        == "🦨"
      )
    }
    try test(Dictionary.self)
    try test(OrderedDictionary.self)
  }

// MARK: - Methods
  @Test func mapKeys() {
    func test<Dictionary: DictionaryProtocol<Int, String>>(_: Dictionary.Type) {
      let dictionary = [100: "💯", 17: "📅"] as Dictionary
      #expect(
        dictionary.mapKeys(String.init)
        == ["100": "💯", "17": "📅"]
      )
      #expect(
        dictionary.compactMapKeys { $0 > 50 ? $0 : nil }
        == [100: "💯"]
      )

      #expect(
        ["🐯": 1, "🦁": 2].mapKeys( { _ in "😺" }, uniquingKeysWith: + )
        == ["😺": 3]
      )
    }
    test(Dictionary.self)
    test(OrderedDictionary.self)
  }

  @Test func mapValues() {
    func test<Dictionary: DictionaryProtocol<String, String>>(_: Dictionary.Type) {
      #expect(
        ( [ "🍍": "🥐",
            "🥝": "🥯"
          ] as Dictionary
        ).mapToValues { tropicalFruit, _ in tropicalFruit }
        == [
          "🍍": "🍍",
          "🥝": "🥝"
        ]
      )
    }
    test(Dictionary.self)
    test(OrderedDictionary.self)
  }

  @Test func merge() throws {
    struct Error: Swift.Error { }
    func test<Dictionary: DictionaryProtocol<String, String> & Equatable>(_: Dictionary.Type) {
      do throws(Error) {
        var dictionary = ["👁": "👀"] as Dictionary
        try dictionary.merge(["🍩": "🍩"] as KeyValuePairs) { oldValue, _ throws(Error) in oldValue }
        #expect(dictionary == ["👁": "👀", "🍩": "🍩"])
      } catch { }
    }
    test(Dictionary.self)
    test(OrderedDictionary.self)
  }

  @Test func path() {
    func test<Dictionary: DictionaryProtocol<String, String> & Equatable>(_: Dictionary.Type) {
      let dictionary = [
        "👣": "🐾",
        "🐾": "🦶",
      ] as Dictionary
      #expect(
        dictionary.path(to: "👣").map(Array.init)
        == ["🦶", "🐾", "👣"]
      )
      #expect(dictionary.path(to: "🏈") == nil)
    }
    test(Dictionary.self)
    test(OrderedDictionary.self)
  }
}
