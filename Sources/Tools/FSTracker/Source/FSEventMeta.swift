public struct FSEventMeta {
    public let path: String
    public let name: String
    public let action: FSActions
    public let description: FSDescription

    public init(
        url: URL,
        action: String,
        description: String
    ) {
        self.path = url.path()
        self.name = url.lastPathComponent
        self.action = action
        self.description = description
    }
}

public enum FSDescription: String, CaseIterable {
    case itemIsntRecognized = "Isn't recognized"

    case itemIsFile         = "Is file"
    case itemIsSymlink      = "Is symlink"
    case itemIsDir          = "Is directory"
}

public enum FSActions: String, CaseIterable {
    case .noChanges        = "No changes"

    case itemCreated       = "Created"
    case itemRemoved       = "Removed"
    case itemRenamed       = "Renamed"
    case itemChangeOwner   = "Changed owner"

    case itemModified      = "Modified"
    case itemInodeMetaMod  = "Mofidied inode meta"
    case itemFinderInfoMod = "Modified finder info"
    case itemXattrMod      = "Modified extended attributes"
}
