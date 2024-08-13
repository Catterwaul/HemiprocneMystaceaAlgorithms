import HeapModule

public extension Heap {
  /// The elements of this heap, from lowest to highest priority.
  @inlinable var sorted: some Sequence<Element> {
    sequence(state: self) { $0.popMin() }
  }

  /// The elements of this heap, from highest to lowest priority.
  @inlinable var reversed: some Sequence<Element> {
    sequence(state: self) { $0.popMax() }
  }
}
