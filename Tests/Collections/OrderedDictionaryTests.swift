import typealias Collections.OrderedDictionary
import HMAlgorithms
import Testing

struct OrderedDictionaryTests {
  @Test func init_grouping_KeyValuePairs() {
    let dictionary: OrderedDictionary = [
      "🔑": [
        "🐅",
        "🐆",
        "🐈"
      ],
      "🗝": [
        "🦖",
        "🦕"
      ]
    ]

    #expect(
      OrderedDictionary(
        grouping: [
          ("🔑", "🐅"),
          ("🔑", "🐆"),
          ("🔑", "🐈"),

          ("🗝", "🦖"),
          ("🗝", "🦕")
        ]
      ) == dictionary
    )

    #expect(
      OrderedDictionary(
        grouping: [
          "🔑": "🐅",
          "🔑": "🐆",
          "🔑": "🐈",

          "🗝": "🦖",
          "🗝": "🦕"
        ] as KeyValuePairs
      ) == dictionary
    )
  }
}
