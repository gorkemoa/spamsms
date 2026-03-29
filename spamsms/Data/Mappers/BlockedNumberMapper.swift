import Foundation

enum BlockedNumberMapper {

    static func toDomain(_ persisted: PersistedBlockedNumber) -> BlockedNumber? {
        let phone = PhoneNumber(alreadyNormalized: persisted.normalizedNumber)
        let category = SpamCategory(rawValue: persisted.categoryRawValue) ?? .custom
        return BlockedNumber(
            id: persisted.id,
            phoneNumber: phone,
            label: persisted.label,
            category: category,
            blockedAt: persisted.blockedAt
        )
    }

    static func toPersisted(_ domain: BlockedNumber) -> PersistedBlockedNumber {
        PersistedBlockedNumber(
            id: domain.id,
            normalizedNumber: domain.phoneNumber.normalized,
            originalNumber: domain.phoneNumber.normalized,
            label: domain.label,
            categoryRawValue: domain.category.rawValue,
            blockedAt: domain.blockedAt
        )
    }
}
