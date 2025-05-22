//  Created by Andrew Steellson on 20.04.2025.

import Foundation

/// `` ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ``
/// `` ☩   Scripter    ☩ ``
/// `` ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ``

/// __ IN PROGRESS  __
/// __ USAGE DONT RECOMENDED __

public struct Scripter {
    /// Enviroment where script will be lanunched
    public enum Shell: String {
        case sh, zsh, fish
    }
    /// Run bash script
    /// - Parameters:
    ///   - path: Place where script stored
    ///   - args: Classic command line arguments
    /// - Returns: Console output
    @discardableResult
    public static func run(
        _ path: String?,
        shell: Shell = .sh,
        args: String...
    ) -> String {
        let shellPath = "/bin/" + shell.rawValue
        let process = Process()
        process.launchPath = path ?? shellPath
        process.arguments = args

        let pipe = Pipe()
        process.standardOutput = pipe
        process.launch()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: String.Encoding.utf8)

        return output ?? ""
    }
}
