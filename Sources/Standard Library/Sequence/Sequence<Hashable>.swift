import OrderedCollections

public extension Sequence where Element: Hashable {
  /// Whether every element in this sequence is unique.
  var containsOnlyUniqueElements: Bool {
    do {
      _ = try Set(unique: self)
      return true
    } catch {
      return false
    }
  }

  /// The non-unique elements of this collection, in the order of their first occurrences.
  var duplicates: OrderedSet<Element> {
    OrderedDictionary(bucketing: self).filter { $1 > 1 }.keys
  }

  /// The unique elements of this collection, in the order of their first occurrences.
  var uniqueElements: OrderedSet<Element> {
    OrderedDictionary(bucketing: self)
      .filter { $0.value == 1 }
      .keys
  }

  /// Matches interleaved subsequences of identical elements with separate iterations of some other sequence.
  func withKeyedIterations<Sequence: Swift.Sequence>(of sequence: Sequence)
  -> [(Element, Sequence.Element)] {
    var iterators: [Element: Sequence.Iterator] = [:]
    return map {
      ($0, iterators[$0, default: sequence.makeIterator()].next()!)
    }
  }
}

public extension LazySequenceProtocol where Element: Hashable {
  /// The unique elements of this collection, in the order of their first occurrences.
  var uniqueElements: some Sequence<Element> {
    OrderedDictionary(bucketing: self)
      .lazy
      .filter { $0.value == 1 }
      .map(\.key)
  }
}
