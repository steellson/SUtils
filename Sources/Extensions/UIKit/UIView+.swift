//  Created by Andrew Steellson on 02.04.2025.

#if canImport(UIKit)
import UIKit
#if canImport(SnapKit)
import SnapKit
#endif

/// `` ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ``
/// `` ☩   UIView +  ☩ ``
/// `` ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ``

public extension UIView {
	/// A Boolean value indicating whether view is not hidden
    public var isNotHidden: Bool { !isHidden }

    /// Fade in a view with a duration
    /// - Parameters:
    ///   - duration: Custom animation duration
    ///   - completion: Optional handler
    public func fadeIn(
        duration: TimeInterval = 1.0,
        completion: TypedBlock<Bool>?
    ) {
        UIView.animate(
            withDuration: duration,
            animations: { self.alpha = 1.0 },
            completion: completion
        )
    }

    /// Fade out a view with a duration
    /// - Parameters:
    ///   - duration: Custom animation duration
    ///   - completion: Optional handler
    public func fadeOut(
        duration: TimeInterval = 1.0,
        completion: TypedBlock<Bool>?
    ) {
        UIView.animate(
            withDuration: duration,
            animations: { self.alpha = 0.0 },
            completion: completion
        )
    }
    
    /// Common addSubview with `tAMIC`=`false`
    /// - Parameter views: View for adding
    public func addNewSubviews(_ view: UIView) {
        view.translateAutoresizingMaskIntoConstraints = false
        addSubview(view)
    }

    #if canImport(SnapKit)
    /// Add subview and make constraints
    /// - Parameters:
    ///   - view: View for adding
    ///   - closure: Constraints block
    public func addSubview(
        _ view: UIView,
        _ closure: TypedBlock<ConstraintMaker>
    ) {
        view.translateAutoresizingMaskIntoConstraints = false
        addSubview(view)
        view.snp.makeConstraints(closure)
    }
    #endif
}
#endif
