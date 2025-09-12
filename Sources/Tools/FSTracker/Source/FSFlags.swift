//  Created by Andrew Steellson on 07.09.2025.
//

import Foundation

/// `` ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ``
/// `` ☩   FSFlags   ☩ ``
/// `` ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ``

public enum FSFlags: UInt32, CaseIterable {
    case noChanges         = 0
    case itemCreated       = 0x00000100
    case itemRemoved       = 0x00000200
    case itemInodeMetaMod  = 0x00000400
    case itemRenamed       = 0x00000800
    case itemModified      = 0x00001000
    case itemFinderInfoMod = 0x00002000
    case itemChangeOwner   = 0x00004000
    case itemXattrMod      = 0x00008000
    case itemIsFile        = 0x00010000
    case itemIsDir         = 0x00020000
    case itemIsSymlink     = 0x00040000

    /// Take values with bitmask
    /// - Parameter encodedFlags: Number from FS (Combinated flags)
    /// - Returns: Array of understandable events from file system
    public static func parse(_ encodedFlags: UInt32) -> [FSFlags] {
        return FSFlags.allCases.filter { encodedFlags & $0.rawValue != 0 }
    }
}
