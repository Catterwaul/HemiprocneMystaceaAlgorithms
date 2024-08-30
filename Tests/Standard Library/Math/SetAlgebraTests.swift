import HMAlgorithms
import Testing

struct SetAlgebraTests {
  @Test func init_unique() throws {
    #expect(throws: Set<Int>.Error.DuplicateElement.self) { try Set(unique: [1, 1]) }
    #expect(throws: Never.self) { try Set(unique: [1, 2]) }
  }
}
