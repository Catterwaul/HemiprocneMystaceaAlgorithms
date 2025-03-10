import HMAlgorithms
import Testing

struct HashableViaIDTests {
  @Test func testEquality() {
    struct S: HashableViaID {
      let id: String
    }

    #expect(S(id: "🆔") == S(id: "🆔"))
    #expect(S(id: "🆔") != S(id: "💡"))
  }
}
