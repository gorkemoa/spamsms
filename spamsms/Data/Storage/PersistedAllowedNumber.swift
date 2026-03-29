import SwiftData
import Foundation

@Model
final class PersistedAllowedNumber {
    @Attribute(.unique) var id: UUID
    var normalizedNumber: String
    var originalNumber: String
    var label: String
    var addedAt: Date

    init(
        id: UUID,
        normalizedNumber: String,
        originalNumber: String,
        label: String,
        addedAt: Date
    ) {
        self.id = id
        self.normalizedNumber = normalizedNumber
        self.originalNumber = originalNumber
        self.label = label
        self.addedAt = addedAt
    }
}
