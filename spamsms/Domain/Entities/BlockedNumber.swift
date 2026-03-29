import Foundation

/// A number the user has explicitly blocked.
struct BlockedNumber: Identifiable, Hashable, Codable, Sendable {
    let id: UUID
    let phoneNumber: PhoneNumber
    var label: String
    var category: SpamCategory
    let blockedAt: Date

    init(
        id: UUID = UUID(),
        phoneNumber: PhoneNumber,
        label: String = "",
        category: SpamCategory = .custom,
        blockedAt: Date = Date()
    ) {
        self.id = id
        self.phoneNumber = phoneNumber
        self.label = label
        self.category = category
        self.blockedAt = blockedAt
    }
}
