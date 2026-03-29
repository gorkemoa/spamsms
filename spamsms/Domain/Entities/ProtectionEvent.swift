import Foundation

/// A log entry for a protection action (blocked call, filtered message, etc.).
struct ProtectionEvent: Identifiable, Codable, Sendable {
    let id: UUID
    let type: ProtectionEventType
    /// Masked representation — never stores raw phone number.
    let maskedIdentifier: String
    let decision: FilterDecision
    let occurredAt: Date

    init(
        id: UUID = UUID(),
        type: ProtectionEventType,
        maskedIdentifier: String,
        decision: FilterDecision,
        occurredAt: Date = Date()
    ) {
        self.id = id
        self.type = type
        self.maskedIdentifier = maskedIdentifier
        self.decision = decision
        self.occurredAt = occurredAt
    }
}

enum ProtectionEventType: String, Codable, Sendable {
    case callBlocked    = "call_blocked"
    case callIdentified = "call_identified"
    case smsFiltered    = "sms_filtered"

    var localizedTitle: String {
        switch self {
        case .callBlocked:    return "event.type.call_blocked".localized()
        case .callIdentified: return "event.type.call_identified".localized()
        case .smsFiltered:    return "event.type.sms_filtered".localized()
        }
    }

    var systemImageName: String {
        switch self {
        case .callBlocked:    return "phone.down.fill"
        case .callIdentified: return "person.fill.questionmark"
        case .smsFiltered:    return "message.badge.filled.fill"
        }
    }
}
