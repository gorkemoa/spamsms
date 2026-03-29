import SwiftData
import Foundation

@Model
final class PersistedSpamRule {
    @Attribute(.unique) var id: UUID
    var patternType: String   // "keyword" | "regex"
    var patternValue: String
    var categoryRawValue: String
    var isEnabled: Bool
    var label: String
    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID,
        patternType: String,
        patternValue: String,
        categoryRawValue: String,
        isEnabled: Bool,
        label: String,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.patternType = patternType
        self.patternValue = patternValue
        self.categoryRawValue = categoryRawValue
        self.isEnabled = isEnabled
        self.label = label
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
