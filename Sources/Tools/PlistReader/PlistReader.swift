//  Created by Andrew Steellson on 30.03.2025.

import Foundation

/// `` ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ``
/// `` ☩    PlistReader    ☩ ``
/// `` ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ``

public struct PlistReader {
    public enum PlistError: Error {
        case fileNotFound(path: String)
        case invalidFormat
    }
    
    /// Read any `.plist` file at path
    /// - Parameter path: Place when file stored
    /// - Returns: Files content with keys and values representation
    public static func read(
        atPath path: String
    ) throws -> [String: Any] {
        let url = URL(fileURLWithPath: path)

        guard FileManager.default.fileExists(atPath: path) else {
            throw PlistError.fileNotFound(path: path)
        }

        let data = try Data(contentsOf: url)
        guard let plist = try PropertyListSerialization.propertyList(
            from: data,
            options: [],
            format: nil
        ) as? [String: Any] else {
            throw PlistError.invalidFormat
        }

        return plist
    }
}
