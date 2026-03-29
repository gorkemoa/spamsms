import Foundation

enum ProtectionEventMapper {

    static func toDomain(_ persisted: PersistedProtectionEvent) -> ProtectionEvent? {
        guard
            let type = ProtectionEventType(rawValue: persisted.typeRawValue),
            let verdict = FilterVerdict(rawValue: persisted.verdictRawValue)
        else { return nil }

        let category = persisted.triggeringCategoryRawValue.flatMap { SpamCategory(rawValue: $0) }
        let decision = FilterDecision(
            verdict: verdict,
            reason: persisted.reason,
            triggeringCategory: category
        )
        return ProtectionEvent(
            id: persisted.id,
            type: type,
            maskedIdentifier: persisted.maskedIdentifier,
            decision: decision,
            occurredAt: persisted.occurredAt
        )
    }

    static func toPersisted(_ domain: ProtectionEvent) -> PersistedProtectionEvent {
        PersistedProtectionEvent(
            id: domain.id,
            typeRawValue: domain.type.rawValue,
            maskedIdentifier: domain.maskedIdentifier,
            verdictRawValue: domain.decision.verdict.rawValue,
            reason: domain.decision.reason,
            triggeringCategoryRawValue: domain.decision.triggeringCategory?.rawValue,
            occurredAt: domain.occurredAt
        )
    }
}
