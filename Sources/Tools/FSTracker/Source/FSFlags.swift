//  Created by Andrew Steellson on 07.09.2025.
//

import Foundation

/// `` ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ``
/// `` ☩   FSFlags   ☩ ``
/// `` ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ``

public enum FSFlags: UInt32, CaseIterable {
    case noChanges         = 0
    case itemCreated       = 1
    case itemRemoved       = 2
    case itemInodeMetaMod  = 4
    case itemModified      = 8
    case itemRenamed       = 16
    case itemFinderInfoMod = 32
    case itemChangeOwner   = 64
    case itemXattrMod      = 128
    case itemIsFile        = 256
    case itemIsDir         = 512
    case itemIsSymlink     = 1024
    case itemHardlink      = 2048
    case itemUnmount       = 4096
    case itemUnmounted     = 8192
    case itemRootModified  = 16384
    case itemRoot          = 32768

    /// Take values with bitmask
    /// - Parameter eventFlags: Number from FS (Combinated flags)
    /// - Returns: Array of understandable events from file system
    public static func parse(_ eventFlags: UInt32) -> [FSEvent] {
        return FSFlags.allCases
            .filter { eventFlags & $0.rawValue != 0 }
            .compactMap { FSEvent($0) }
    }
}
