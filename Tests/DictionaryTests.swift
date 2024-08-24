import Testing

struct DictionaryTests {
  @Test func init_grouping_KeyValuePairs() {
    let keyValuePairs = [("🔑", "🐅"), ("🗝", "🦖")]
    _ = Dictionary(grouping: keyValuePairs) // No crash.
    func test<Dictionary: DictionaryProtocol<String, [String]>>(_: Dictionary.Type) {
      _ = Dictionary(grouping: keyValuePairs) // EXC_BAD_ACCESS
    }
    test(Dictionary.self)
  }
}

protocol DictionaryProtocol<Key, Value> {
  associatedtype Key
  associatedtype Value

  init<ValueElement>(grouping pairs: some Sequence<(Key, ValueElement)>)
  where Value == [ValueElement]
}

extension Dictionary: DictionaryProtocol {
  init<ValueElement>(grouping pairs: some Sequence<(Key, ValueElement)>)
  where Value == [ValueElement] {
    self = [_: _](grouping: pairs, by: \.0).mapValues { $0.map(\.1) }
  }
}
