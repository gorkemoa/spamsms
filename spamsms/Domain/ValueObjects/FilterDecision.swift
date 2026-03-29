import Foundation

/// The outcome of evaluating a spam filter rule against a message or call.
enum FilterVerdict: String, Codable, Sendable {
    case allow
    case block
    case none
}

/// Result produced by the rule engine for a single evaluation.
struct FilterDecision: Codable, Sendable {
    let verdict: FilterVerdict
    /// Human-readable explanation (never contains raw content).
    let reason: String
    /// The category that triggered the decision, if any.
    let triggeringCategory: SpamCategory?

    static func allow(reason: String) -> FilterDecision {
        FilterDecision(verdict: .allow, reason: reason, triggeringCategory: nil)
    }

    static func block(reason: String, category: SpamCategory? = nil) -> FilterDecision {
        FilterDecision(verdict: .block, reason: reason, triggeringCategory: category)
    }

    static let noMatch = FilterDecision(verdict: .none, reason: "no_match", triggeringCategory: nil)
}
