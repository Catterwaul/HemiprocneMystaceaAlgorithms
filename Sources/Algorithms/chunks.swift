import Algorithms

public extension Collection {
  /// Split the collection into a total number of chunks.
  /// - Parameter totalCount:
  ///   If this is not evenly divided by the count of the base `Collection`,
  ///   the last chunk will contain more elements than all of the other chunks.
  func chunks(totalCount: Int) -> some Sequence<SubSequence> {
    let (chunkSize, remainder) = count.quotientAndRemainder(dividingBy: totalCount)
    return chain(
      chunks(ofCount: chunkSize).dropLast(remainder == 0 ? 1 : 2),
      suffix(chunkSize + remainder)
    )
  }
}
