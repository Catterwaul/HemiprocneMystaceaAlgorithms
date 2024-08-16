import HMAlgorithms
import Testing

struct ZipTests {
  @Test func _zip() {
    #expect(
      zip(1...3, constant: "🧛🏼")
        .elementsEqual([(1, "🧛🏼"), (2, "🧛🏼"), (3, "🧛🏼")], by: ==)
    )
  }
}
