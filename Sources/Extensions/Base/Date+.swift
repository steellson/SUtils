//  Created by Andrew Steellson on 02.04.2025.

import Foundation

/// `` ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ``
/// `` ☩    Date +   ☩ ``
/// `` ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ``

public extension Date {
    /// Common timestamp
    public var timestamp: String? {
        let formatter = DateFormatter()
        formatter.timeStyle = .long
        let datetime = formatter.string(from: self)
        let utc = datetime.components(separatedBy: " ")
            .last?
            .components(separatedBy: "GMT")
            .last
        return utc
    }

    /// Formatted and localized date
    /// - Parameters:
    ///   - date: Some date value
    ///   - dateFormat: Required format string
    ///   - locale: Optional, base localized
    /// - Returns: Localized date string
    public func stringDate(
        from date: Date,
        dateFormat: String,
        locale: Locale = Locale(identifier: "en_RU")
    ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.locale = locale
        return dateFormatter.string(from: date)
    }

    /// Formatted current date
    /// - Parameters:
    ///   - dateFormat: Required format string
    ///   - locale: Optional, base localized
    /// - Returns: Current localized date string
    public func currentDate(
        dateFormat: String,
        locale: Locale = Locale(identifier: "en_RU")
    ) -> String {
        stringDate(
            from: Date(),
            dateFormat: dateFormat,
            locale: locale
        )
    }
    
    /// Formatted yesterday date
    /// - Parameter dateFormat: Required format string
    /// - Returns: Yesterday localized date string
    public func yesterdayDate(
        dateFormat: String
    ) -> String {
        stringDate(
            from: Date(timeIntervalSinceNow: -(3600 * 24)),
            dateFormat: dateFormat
        )
    }
}
