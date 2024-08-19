import HMAlgorithms
import var Some.error
import Testing

struct EnumeratedSequenceTests {
  @Test func mapElements() throws {
    #expect {
      try ["🚽", "🛁"]
        .enumerated()
        .mapElements {
          guard $0 == "🚽" else { throw error }
        }
    } throws: { error in
      (error as? EnumeratedSequence<[String]>.Error)?.index == 1
    }
  }
}
