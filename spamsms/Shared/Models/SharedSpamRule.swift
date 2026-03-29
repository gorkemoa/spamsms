import Foundation

/// Lightweight rule model shared between the main app and the Message Filter Extension.
struct SharedSpamRule: Codable, Sendable {
    enum PatternType: String, Codable { case keyword, regex }

    let id: UUID
    let patternType: PatternType
    let patternValue: String
    let categoryRawValue: String
    let isEnabled: Bool

    init(from rule: SpamRule) {
        self.id = rule.id
        switch rule.pattern {
        case .keyword(let word):
            self.patternType = .keyword
            self.patternValue = word
        case .regex(let expr):
            self.patternType = .regex
            self.patternValue = expr
        }
        self.categoryRawValue = rule.category.rawValue
        self.isEnabled = rule.isEnabled
    }

    var messagePattern: MessagePattern {
        switch patternType {
        case .keyword: return .keyword(patternValue)
        case .regex:   return .regex(patternValue)
        }
    }
}
