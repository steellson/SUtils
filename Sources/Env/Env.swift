//  Created by Andrew Steellson on 29.03.2025.

import Foundation

/// `` ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ``
/// `` ☩    Environment    ☩ ``
/// `` ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ``

/// __ Follow inscturcions below to use this environment impl __
///
/// ** 1. Setup .plist
/// - Declare all keys in your`Info.plist`
/// - Declare all values for this keys as like ``$(API_KEY)`
///
/// ** 2. Setup build configurations
/// - COPY or CREATE this into your main project bundle `!!!`
///     - `Configuration` folder with required files:
///         - ``Release.xcconfig``
///         - ``Development.xcconfig``
/// - Register this files into project settings (place where it will be stored in bundle is't important)
/// - Fill up configuration files in format as like ``API_KEY = 111``
///
/// ** 3. Create keys in code
/// - Create env keys cases using enum as like `enum EnvKeys: String {}`
///
/// ** 4. Read variables
/// - Try to call `Env.value<EnvKeys>(_ forKey: .apiKey)`
/// - Now you should receive result based on build configuration
///
/// __  ALL KEYS AND VALUES MUST BE REGISTERED IN INFO.PLIST __

public enum Env<T: RawRepresentable> {
    public enum EnvError: Error {
        case missingPlist
        case missingKey
        case invalidKey
        case invalidValue
    }
}

// MARK: - Read
public extension Env {
    /// Take variable from `Info.plist`
    /// - Parameter forKey: Parameter's keyword
    /// - Returns: Value for regiestered key
    static func value(_ forKey: T) throws -> String {
        guard let key = forKey.rawValue as? String else {
            log(.invalidKey)
            throw EnvError.invalidKey
        }

        do {
            let properties = try PlistReader.read(
                atPath: propertiesPath
            )
            guard let object = properties[key] else {
                log(.missingKey, key)
                throw EnvError.missingKey
            }
            guard let value = object as? String else {
                log(.invalidValue, key)
                throw EnvError.invalidValue
            }

            log(nil, value)
            return value
        } catch {
            log(.missingPlist, error.localizedDescription)
            throw EnvError.missingPlist
        }
    }
}

// MARK: - Process (Private)
private extension Env {
    /// Path to `.plist` in project main bundle
    static var propertiesPath: String {
        let propertiesList = "Config"
        let fileExtension = ".plist"
        let bundle = Bundle.main

        return bundle.path(
            forResource: propertiesList,
            ofType: fileExtension
        ) ?? bundle.bundlePath
    }

    /// Internal logs
    static func log(
        _ error: EnvError?,
        _ info: String = ""
    ) {
        let reaction = switch error {
        case .none:         "✅"
        case .missingKey:   "🔑"
        case .invalidKey:   "🔐"
        case .missingPlist: "📋"
        case .invalidValue: "😿"
        }

        let text = switch error {
        case .none:         "Read value '\(info)'"
        case .missingKey:   "Key isn't exist: \(info)"
        case .missingPlist: "Cant load .plist: \(info)"
        case .invalidValue: "Cant load value: \(info)"
        case .invalidKey:   "Invalid key type! \(info)"
        }

        let instance = "[Env]"
        let log = "\(reaction) \(instance) \(text)"

        switch error {
        case .none: Log.info("\(log)")
        default:    Log.error("\(log)")
        }
    }
}
