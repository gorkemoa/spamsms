import Foundation

enum AllowedNumberMapper {

    static func toDomain(_ persisted: PersistedAllowedNumber) -> AllowedNumber {
        let phone = PhoneNumber(alreadyNormalized: persisted.normalizedNumber)
        return AllowedNumber(
            id: persisted.id,
            phoneNumber: phone,
            label: persisted.label,
            addedAt: persisted.addedAt
        )
    }

    static func toPersisted(_ domain: AllowedNumber) -> PersistedAllowedNumber {
        PersistedAllowedNumber(
            id: domain.id,
            normalizedNumber: domain.phoneNumber.normalized,
            originalNumber: domain.phoneNumber.normalized,
            label: domain.label,
            addedAt: domain.addedAt
        )
    }
}
