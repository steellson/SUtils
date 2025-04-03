//  Created by Andrew Steellson on 02.04.2025.

#if canImport(UIKit)
import UIKit

/// `` ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ``
/// `` ☩     UIStackView +     ☩ ``
/// `` ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ``

public extension UIStackView {
    /// To clear all subviews from stack
    public func removeAllArrangedSubviews() {
        arrangedSubviews.forEach { [weak self] in
            self?.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }
}
#endif
