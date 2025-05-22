//  Created by Andrew Steellson on 03.05.2025.

import Foundation

/// `` ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ``
/// `` ☩    Chroner    ☩ ``
/// `` ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ``

open class Chroner<T: Numeric> {
    private let step: T
    private var finished: Bool {
        remaining == .zero || elapsed == duration
    }

    open var elapsed:   T = .zero
    open var remaining: T = .zero
    open var duration:  T = .zero

    public init(step: T) {
        self.step = step
    }

    open func tick() {
        sleep(1)
        elapsed += 1
        remaining -= 1
    }

    open func reset() {
        elapsed = .zero
        remaining = duration
    }

    open func autoStop(_ stop: () throws -> Void) throws {
        if finished { try stop() }
    }
}
