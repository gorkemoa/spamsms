import Foundation

/// A single entry for Call Directory — used to populate CallKit with blocked/identified numbers.
struct CallIdentificationEntry: Hashable, Codable, Sendable {
    let normalizedNumber: String
    let label: String
    let shouldBlock: Bool

    init(blockedNumber: BlockedNumber) {
        self.normalizedNumber = blockedNumber.phoneNumber.normalized
        self.label = blockedNumber.label.isEmpty
            ? blockedNumber.category.localizedTitle
            : blockedNumber.label
        self.shouldBlock = true
    }
}
