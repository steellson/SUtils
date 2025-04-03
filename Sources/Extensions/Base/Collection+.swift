//  Created by Andrew Steellson on 02.04.2025.

import Foundation

/// `` ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ``
/// `` ☩      Collection +     ☩ ``
/// `` ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ``

public extension Collection {
    /// A Boolean value indicating whether the collection is not empty.
    public var isNotEmpty: Bool {
        !isEmpty
    }

	/// Returns the element at the specified index iff it is within bounds, otherwise nil.
	public subscript (safe index: Index) -> Element? {
		return indices.contains(index) ? self[index] : nil
	}
}

public extension Collection where Element: Hashable {
    /// Remove all clones
    /// - Returns: Unique collection
    public func removeDuplicates() -> [Element] {
        return reduce(
            into: (result: [Element](), seen: Set<Element>())
        ) {
            guard $0.seen.insert($1).inserted else { return }

            $0.result.append($1)
        }.result
    }
}
