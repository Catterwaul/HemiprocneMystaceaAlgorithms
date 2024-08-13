import HMAlgorithms
import HeapModule
import Testing

struct HeapTests {
  @Test func sorted_reversed() {
    let heap = [1, 0, 2, 0, -3] as Heap
    #expect(Array(heap.sorted) == heap.reversed.reversed())
  }
}
