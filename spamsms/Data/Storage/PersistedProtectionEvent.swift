import SwiftData
import Foundation

@Model
final class PersistedProtectionEvent {
    @Attribute(.unique) var id: UUID
    var typeRawValue: String
    var maskedIdentifier: String
    var verdictRawValue: String
    var reason: String
    var triggeringCategoryRawValue: String?
    var occurredAt: Date

    init(
        id: UUID,
        typeRawValue: String,
        maskedIdentifier: String,
        verdictRawValue: String,
        reason: String,
        triggeringCategoryRawValue: String?,
        occurredAt: Date
    ) {
        self.id = id
        self.typeRawValue = typeRawValue
        self.maskedIdentifier = maskedIdentifier
        self.verdictRawValue = verdictRawValue
        self.reason = reason
        self.triggeringCategoryRawValue = triggeringCategoryRawValue
        self.occurredAt = occurredAt
    }
}
