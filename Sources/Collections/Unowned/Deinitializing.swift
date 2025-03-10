import protocol Combine.Publisher

/// Something which publishes the event of its own deinitialization.
public protocol Deinitializing<DeinitPublisher> {
  associatedtype DeinitPublisher: Publisher<Self, Never>
  var deinitPublisher: DeinitPublisher { get }
}
