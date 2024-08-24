import Testing

@Test func bug() {
  _ = Struct(1) // No crash.

  func test<P: Protocol<[Int]>>(_: P.Type) {
    _ = P(1) // EXC_BAD_ACCESS
  }
  test(Struct.self)
}

protocol Protocol<Value> {
  associatedtype Value

  init<ValueElement>(_: ValueElement) where Value == [ValueElement]
}

struct Struct<Value>: Protocol {
  init() { }

  init<ValueElement>(_: ValueElement) where Value == [ValueElement] {
    self.init()
  }
}
