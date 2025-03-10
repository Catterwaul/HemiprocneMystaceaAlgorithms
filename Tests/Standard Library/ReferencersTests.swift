import Combine
import HMAlgorithms
import Testing

struct ReferencersTests {
  // MARK: - Unowned
  @Test func unowned() {
    var object: Object! = Object()
    @Unowned var unowned = object
    weak var weak = unowned
    #expect(weak != nil)
    object = nil
    #expect(weak == nil)
  }

  @Test func unownedSetRemoval() {
    final class SetBox {
      @Unowned.Dictionary var dictionary: [ObjectIdentifier: Unowned<Object>]
      init(_ objects: some Sequence<Object>) {
        _dictionary = .init(objects, key: \.id)
      }
    }
    var object: Object! = Object()
    @Unowned var unowned = object
    let box = SetBox([object])
    #expect(!box.dictionary.isEmpty)
    object = nil
    #expect(box.dictionary.isEmpty)
  }
}

private final class Object: HashableViaID {
  private let _deinitPublisher = PassthroughSubject<Object, Never>()
  deinit { _deinitPublisher.send(self) }
}

extension Object: Deinitializing {
  var deinitPublisher: some Publisher<Object, Never> { _deinitPublisher }
}
