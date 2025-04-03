//  Created by Andrew Steellson on 02.04.2025.

#if canImport(UIKit)
import UIKit

/// `` ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ``
/// `` ☩  UICollectionView +   ☩ ``
/// `` ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ``

/// Convenience extension for registration and dequing members
/// Using external protocol `Reusable`
public extension UICollectionView {
    public final func register<T: UICollectionViewCell>(
        _ cellType: T.Type
    ) where T: Reusable {
        register(
            cellType.self,
            forCellWithReuseIdentifier: cellType.reuseIdentifier
        )
    }

    public final func registerHeader<T: UICollectionReusableView>(
        _ headerType: T.Type
    ) where T: Reusable {
        register(
            headerType.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: headerType.reuseIdentifier
        )
    }

    public final func registerFooter<T: UICollectionReusableView>(
        _ headerType: T.Type
    ) where T: Reusable {
        register(
            headerType.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: headerType.reuseIdentifier
        )
    }

    public final func dequeue<T: UICollectionViewCell>(
        for indexPath: IndexPath,
        cellType: T.Type = T.self
    ) -> T where T: Reusable {
        guard let cell = dequeueReusableCell(
            withReuseIdentifier: cellType.reuseIdentifier,
            for: indexPath
        ) as? T else {
            fatalError("Failed to dequeue a cell with identifier \(cellType.reuseIdentifier) matching type \(cellType.self)")
        }
        return cell
    }

    public final func dequeue<T: UICollectionReusableView>(
        for indexPath: IndexPath,
        kind: String,
        cellType: T.Type = T.self
    ) -> T where T: Reusable {
        guard let cell = self.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: cellType.reuseIdentifier,
            for: indexPath
        ) as? T else {
            fatalError("Failed to dequeue a cell with identifier \(cellType.reuseIdentifier) matching type \(cellType.self)")
        }
        return cell
    }
}
#endif
