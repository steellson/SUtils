//  Created by Andrew Steellson on 02.04.2025.

#if canImport(UIKit)
import UIKit

/// `` ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ``
/// `` ☩   UITableViewDiffableDataSource +   ☩ ``
/// `` ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ``

public extension UITableViewDiffableDataSource {
    /// Replace elements in concrent`section` with new `items`
    /// - Parameters:
    ///   - items: Elements should be replaced
    ///   - section: Taget section to replace
    ///   - animated: Is difference will be animated
    public func replaceItems(
        _ items: [ItemIdentifierType],
        in section: SectionIdentifierType,
        animated: Bool = true
    ) {
        var snapshot = snapshot()
        let itemsOfSection = snapshot.itemIdentifiers(
            inSection: section
        )
        snapshot.deleteItems(itemsOfSection)
        snapshot.appendItems(items, toSection: section)
        snapshot.reloadSections([section])
        apply(
            snapshot,
            animatingDifferences: animated
        )
    }
}
#endif
