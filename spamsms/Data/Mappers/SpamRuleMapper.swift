import Foundation

enum SpamRuleMapper {

    static func toDomain(_ persisted: PersistedSpamRule) -> SpamRule {
        let pattern: MessagePattern = persisted.patternType == "regex"
            ? .regex(persisted.patternValue)
            : .keyword(persisted.patternValue)
        let category = SpamCategory(rawValue: persisted.categoryRawValue) ?? .custom
        return SpamRule(
            id: persisted.id,
            pattern: pattern,
            category: category,
            isEnabled: persisted.isEnabled,
            label: persisted.label,
            createdAt: persisted.createdAt,
            updatedAt: persisted.updatedAt
        )
    }

    static func toPersisted(_ domain: SpamRule) -> PersistedSpamRule {
        let (type, value): (String, String) = {
            switch domain.pattern {
            case .keyword(let w): return ("keyword", w)
            case .regex(let r):   return ("regex", r)
            }
        }()
        return PersistedSpamRule(
            id: domain.id,
            patternType: type,
            patternValue: value,
            categoryRawValue: domain.category.rawValue,
            isEnabled: domain.isEnabled,
            label: domain.label,
            createdAt: domain.createdAt,
            updatedAt: domain.updatedAt
        )
    }
}
