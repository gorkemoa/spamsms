import Foundation

/// Describes a matching pattern for SMS content analysis.
enum MessagePattern: Hashable, Codable, Sendable {
    /// Plain keyword match (case-insensitive).
    case keyword(String)
    /// Regular expression pattern.
    case regex(String)

    /// Returns `true` if the pattern matches the given text.
    func matches(_ text: String) -> Bool {
        switch self {
        case .keyword(let word):
            return text.localizedCaseInsensitiveContains(word)
        case .regex(let pattern):
            return (try? NSRegularExpression(pattern: pattern, options: .caseInsensitive))
                .map { $0.firstMatch(in: text, range: NSRange(text.startIndex..., in: text)) != nil }
                ?? false
        }
    }

    var displayValue: String {
        switch self {
        case .keyword(let word): return word
        case .regex(let pattern): return pattern
        }
    }
}
