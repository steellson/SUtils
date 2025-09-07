//  Created by Andrew Steellson on 07.09.2025.
//

import Foundation

/// `` ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ``
/// `` ☩    FSEvent    ☩ ``
/// `` ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ``

public struct FSEvent {
    public let flag: FSFlags
    public let text: String

    public init(
        _ flag: FSFlags
    ) {
        self.flag = flag
        self.text = Self.describe(flag)
    }

    private static func describe(_ flag: FSFlags) -> String {
        return switch flag {
        case .itemCreated:       "Created"
        case .itemRemoved:       "Removed"
        case .itemRenamed:       "Renamed"
        case .itemChangeOwner:   "Changed owner"

        case .itemIsFile:        "Is file"
        case .itemRoot:          "Is root"
        case .itemIsSymlink:     "Is symlink"
        case .itemHardlink:      "Is hardlink"
        case .itemIsDir:         "Is directory"

        case .itemModified:      "Modified"
        case .itemRootModified:  "Mofidied root"
        case .itemInodeMetaMod:  "Mofidied inode meta"
        case .itemFinderInfoMod: "Modified finder info"
        case .itemXattrMod:      "Modified extended attributes"

        case .itemUnmount:       "Unmount"
        case .itemUnmounted:     "Unmounted"
        case .noChanges:         "No changes"
        }
    }
}
