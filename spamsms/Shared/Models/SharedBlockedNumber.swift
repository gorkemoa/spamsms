import Foundation

/// Lightweight model shared between the main app and the Call Directory Extension.
struct SharedBlockedNumber: Codable, Sendable {
    let normalizedNumber: String
    let label: String

    init(from blockedNumber: BlockedNumber) {
        self.normalizedNumber = blockedNumber.phoneNumber.normalized
        self.label = blockedNumber.label.isEmpty
            ? blockedNumber.category.localizedTitle
            : blockedNumber.label
    }
}
