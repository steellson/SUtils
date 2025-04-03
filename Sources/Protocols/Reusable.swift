//  Created by Andrew Steellson on 02.04.2025.

import Foundation

/// `` ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ``
/// `` ☩    Reusable     ☩ ``
/// `` ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ``

/// May be used for reusable objects which required ID
public protocol Reusable {
    static var reuseIdentifier: String { get }
}

public extension Reusable {
    public static var reuseIdentifier: String {
        return String(describing: self)
    }
}
