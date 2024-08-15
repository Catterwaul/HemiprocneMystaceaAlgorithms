import HMAlgorithms
import HeapModule
import Testing

struct HeapTests {
  @Test func sorted_reversed() {
    let heap = [1, 0, 2, 0, -3] as Heap
    #expect(Array(heap.sorted) == heap.reversed.reversed())
  }

  @Test func elementValuePair() {
    final class NotComparable { }
    let evp = Heap.ElementValuePair(1, NotComparable())
    #expect(evp == evp)
    #expect(
      Heap(
        [ (1, nil),
          (1, nil),
          (-1, NotComparable()),
          (0, nil)
        ].map(Heap.ElementValuePair.init)
      ).min?.value != nil
    )
  }
}
