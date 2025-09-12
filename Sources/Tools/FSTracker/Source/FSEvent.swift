//  Created by Andrew Steellson on 07.09.2025.
//

#if (os(macOS))
import Foundation

/// `` ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ``
/// `` ☩    FSEvent    ☩ ``
/// `` ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ``

public struct FSEvent {
    public let file: String
    public let path: String
    public let action: FSFlags?
    public let detail: FSFlags?

    public init(
        url: URL,
        flags: [FSFlags]
    ) {
        var components = url.pathComponents

        let actions: [FSFlags] = [
            .itemCreated,
            .itemRemoved,
            .itemRenamed,
            .itemModified,
            .itemXattrMod,
            .itemChangeOwner,
            .itemInodeMetaMod,
            .itemFinderInfoMod
        ]

        let details: [FSFlags] = [
            .itemIsDir,
            .itemIsFile,
            .itemIsSymlink
        ]

        file = components.removeLast()
        path = components.joined(separator: "/")
        action = flags.filter { actions.contains($0) }.first
        detail = flags.filter { details.contains($0) }.first
    }
}
#endif
