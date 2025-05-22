//  Created by Andrew Steellson on 02.04.2025.

import Foundation

/// `` ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ``
/// `` ☩    Task +   ☩ ``
/// `` ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ``

public extension Task where Success == Never,
                            Failure == Never {
    /// Breaks current task running for setted interval
    /// - Parameter timeInterval: Interval in seconds
    static func sleep(timeInterval: TimeInterval) async throws {
        try await Task.sleep(
            nanoseconds: UInt64(timeInterval * 1e9)
        )
    }
}
