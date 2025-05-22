//  Created by Andrew Steellson on 02.04.2025.

#if canImport(UIKit)
import UIKit
import Protocols

/// `` ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ``
/// `` ☩     UITableView +     ☩ ``
/// `` ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ``

/// Convenience extension for registration and dequing members
/// Using external protocol `Reusable`
public extension UITableView {
    public final func register<T: UITableViewCell>(
        _ cellType: T.Type
    ) where T: Reusable {
        register(
            cellType.self,
            forCellReuseIdentifier: cellType.reuseIdentifier
        )
    }

    public final func register<T: UITableViewHeaderFooterView>(
        _ headerType: T.Type
    ) where T: Reusable {
        register(
            headerType.self,
            forHeaderFooterViewReuseIdentifier: headerType.reuseIdentifier
        )
    }

    public final func dequeue<T: UITableViewCell>(
        for indexPath: IndexPath,
        cellType: T.Type = T.self
    ) -> T where T: Reusable {
        guard let cell = dequeueReusableCell(
            withIdentifier: cellType.reuseIdentifier,
            for: indexPath
        ) as? T else {
            fatalError("Failed to dequeue a cell with identifier \(cellType.reuseIdentifier) matching type \(cellType.self)")
        }
        return cell
    }

    public final func dequeue<T: UITableViewHeaderFooterView>(
        headerType: T.Type = T.self
    ) -> T where T: Reusable {
        guard let header = dequeueReusableHeaderFooterView(
            withIdentifier: headerType.reuseIdentifier
        ) as? T else {
            fatalError("Failed to dequeue a header with identifier \(headerType.reuseIdentifier) matching type \(headerType.self)")
        }
        return header
    }
}
#endif
