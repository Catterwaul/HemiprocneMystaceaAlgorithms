import typealias Collections.OrderedDictionary
import Algorithms
import HMAlgorithms
import Testing

struct DictionaryTests {
  @Test func init_grouping_KeyValuePairs() {
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
}
