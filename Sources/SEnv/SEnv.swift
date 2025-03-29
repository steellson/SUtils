//
//  SEnv.swift
//  STUtilites
//
//  Created by Andrew Steellson on 29.03.2025.
//

import Foundation

/// `` ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ``
/// `` ☩     Enviroment    ☩ ``
/// `` ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ``

public enum SEnv {
    public enum Keys: String {
        case environmentType
        case apiKey
    }
    public enum EnvError: Error {
        case missingKey
        case invalidValue
    }
}

// MARK: - Read
public extension SEnv {
    static func value<T>(
        _ forKey: Keys
    ) throws -> T where T: LosslessStringConvertible {
        let key = forKey.rawValue
        guard let object = Bundle.main.object(forInfoDictionaryKey: key) else {
            throw EnvError.missingKey
        }

        switch object {
            case let string as String:
                guard let value = T(string) else { fallthrough }
                return value
            default:
                SLog.error("😿 [SEnv] Cant get variables for: \(key)")
                throw EnvError.invalidValue
        }
    }
}
