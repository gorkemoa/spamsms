import Foundation

/// A user-managed or built-in rule for spam detection.
struct SpamRule: Identifiable, Hashable, Codable, Sendable {
    let id: UUID
    var pattern: MessagePattern
    var category: SpamCategory
    var isEnabled: Bool
    var label: String
    let createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        pattern: MessagePattern,
        category: SpamCategory,
        isEnabled: Bool = true,
        label: String,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.pattern = pattern
        self.category = category
        self.isEnabled = isEnabled
        self.label = label
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
