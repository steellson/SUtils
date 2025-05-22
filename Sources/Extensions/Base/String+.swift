//  Created by Andrew Steellson on 02.04.2025.

import Foundation

/// `` ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ``
/// `` ☩      String +     ☩ ``
/// `` ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ☩ ``

public extension String {
    /// Helps when works with special sybmols
    static let specialSymbols = CharacterSet(
        charactersIn: "@#$%^*()_+-=[]{};:\\|<>/?₽~€£•"
    )

    /// Helps when works with `emoji` (string recognition etc.)
    static let emojiRanges: [ClosedRange<UnicodeScalar>] = [
        "\u{1F600}"..."\u{1F64F}",  /// Emoticons
        "\u{1F300}"..."\u{1F5FF}",  /// Miscellaneous Symbols and Pictographs
        "\u{1F680}"..."\u{1F6FF}",  /// Transport and Map Symbols
        "\u{1F700}"..."\u{1F77F}",  /// Alchemical Symbols
        "\u{1F780}"..."\u{1F7FF}",  /// Geometric Shapes Extended
        "\u{1F800}"..."\u{1F8FF}",  /// Supplemental Arrows-C
        "\u{1F900}"..."\u{1F9FF}",  /// Supplemental Symbols and Pictographs
        "\u{1FA00}"..."\u{1FA6F}",  /// Chess Symbols
        "\u{1FA70}"..."\u{1FAFF}",  /// Symbols and Pictographs Extended-A
        "\u{2600}"..."\u{26FF}",    /// Miscellaneous Symbols
        "\u{2700}"..."\u{27BF}"     /// Dingbats
    ]

    /// String excluded emoji
    /// `Hell🌐 world` >>> `Hell world`
    var removingEmojis: String {
        return filter {
            guard let scalar = $0.unicodeScalars.first else {
                return true
            }
            return !Self.emojiRanges.contains { $0.contains(scalar) }
        }
    }

    /// Make first character of string uppercased
    /// `some word` >>> `Some word`
    var capitalizedFirstLetter: String {
        guard let first else { return self }

        let range = startIndex ..< index(after: startIndex)
        let character = String(first).uppercased()
        return replacingCharacters(in: range, with: character)
    }

    /// Transformed string from camel case to common sentence
    /// `somethingWentWrong` >>> `Something went wrong`
    var removingCamelCase: String {
        var chars = compactMap { String($0) }

        enumerated().forEach {
            let char = String($1)
            let lower = char.lowercased()
            guard char != lower else { return }

            chars[$0] = " \(lower)"
        }

        return chars.joined().capitalizedFirstLetter
    }

    /// Check is string contains emoji
    var containsEmoji: Bool {
        return unicodeScalars.contains { scalar in
            Self.emojiRanges.contains { range in
                range.contains(scalar)
            }
        }
    }

    /// Check is string contains special characters
    var containsSpecialSymbols: Bool {
        return self.rangeOfCharacter(
            from: Self.specialSymbols
        ) != nil
    }

    /// Check is string formatted as email
    var isEmail: Bool {
        let emailExp = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let email = NSPredicate(format: "SELF MATCHES %@", emailExp)

        return email.evaluate(with: self)
    }

    /// Check is string formatted as birth date
    func isBirthDate() -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"

        return dateFormatter.date(from: self) != nil
    }

    /// Limit string with lenght
    /// - Parameters:
    ///   - length: Final string symbols count
    ///   - hasSuffix: Is shoud be cutted with suffix `...`
    /// - Returns: Cutted string as like `"ABCDEFG..."`
    func limited(
        with length: Int,
        _ hasSuffix: Bool = true
    ) -> String {
        var str = self
        let nsString = str as NSString
        let isOverLength = nsString.length > length

        guard isOverLength else { return str }

        let suffix = hasSuffix ? "..." : ""
        let limitedLenght = nsString.length  + suffix.count
        str = nsString.substring(
            with: NSRange(
                location: .zero,
                length: isOverLength ? length : limitedLenght
            )
        )
        return "\(str)\(suffix)"
    }
}
