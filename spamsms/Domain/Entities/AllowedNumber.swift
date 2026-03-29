import Foundation

/// A trusted number that will never be blocked or filtered.
struct AllowedNumber: Identifiable, Hashable, Codable, Sendable {
    let id: UUID
    let phoneNumber: PhoneNumber
    var label: String
    let addedAt: Date

    init(
        id: UUID = UUID(),
        phoneNumber: PhoneNumber,
        label: String = "",
        addedAt: Date = Date()
    ) {
        self.id = id
        self.phoneNumber = phoneNumber
        self.label = label
        self.addedAt = addedAt
    }
}
