import func Algorithms.product

/// The `product` of 3 underlying collections.
@inlinable public func product3<Base1: Collection, Base2: Collection, Base3: Collection>(
  _ s1: Base1, _ s2: Base2, _ s3: Base3
) -> some Collection<(Base1.Element, Base2.Element, Base3.Element)> {
  product(s1, product(s2, s3)).lazy.map { ($0, $1.0, $1.1) }
}

/// The `product` of 4 underlying collections.
@inlinable public func product4<
  Base1: Collection, Base2: Collection, Base3: Collection, Base4: Collection
>(
  _ s1: Base1, _ s2: Base2, _ s3: Base3, _ s4: Base4
) -> some Collection<(Base1.Element, Base2.Element, Base3.Element, Base4.Element)> {
  product(s1, product3(s2, s3, s4)).lazy.map { ($0, $1.0, $1.1, $1.2) }
}

/// The Cartesian `product` of underlying collections.
/// - Important: This does not use the same ordering as `product` from `Algorithms`.
@inlinable public func product<each Collection: Swift.Collection>(
  _ collection: repeat each Collection
) -> UnfoldSequence<
  (repeat (each Collection).Element),
  (collection: (repeat each Collection), index: (repeat (each Collection).Index))
> {
  var done = false
  for collection in repeat each collection {
    guard !collection.isEmpty else {
      done = true
      break
    }
  }

  return sequence(
    state: (
      collection: (repeat each collection),
      index: (repeat (each collection).startIndex)
    )
  ) { state in
    if done { return nil }

    defer {
      // Advance the index by incrementing the first digit.
      var carry = true

      state.index = (repeat {
        let collection = each state.collection
        var index = each state.index

        // Increment this digit if necessary.
        if carry {
          collection.formIndex(after: &index)
          carry = false
        }

        // Check for wraparound.
        if index < collection.endIndex {
          // Still in range.
          return index
        } else {
          // We wrapped around; increment the next digit.
          carry = true
          return collection.startIndex
        }
      }())

      // If the last digit wrapped around, we're done.
      done = carry
    }

    // Return the current element.
    return (repeat (each state.collection)[each state.index])
  }
}
