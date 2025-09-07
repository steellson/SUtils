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
        case .itemIsSymlink:     "Is symlink"
        case .itemIsDir:         "Is directory"

        case .itemModified:      "Modified"
        case .itemInodeMetaMod:  "Mofidied inode meta"
        case .itemFinderInfoMod: "Modified finder info"
        case .itemXattrMod:      "Modified extended attributes"

        case .noChanges:         "No changes"
        }
    }
}
