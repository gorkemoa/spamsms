import SwiftData
import Foundation

@Model
final class PersistedBlockedNumber {
    @Attribute(.unique) var id: UUID
    var normalizedNumber: String
    var originalNumber: String
    var label: String
    var categoryRawValue: String
    var blockedAt: Date

    init(
        id: UUID,
        normalizedNumber: String,
        originalNumber: String,
        label: String,
        categoryRawValue: String,
        blockedAt: Date
    ) {
        self.id = id
        self.normalizedNumber = normalizedNumber
        self.originalNumber = originalNumber
        self.label = label
        self.categoryRawValue = categoryRawValue
        self.blockedAt = blockedAt
    }
}
