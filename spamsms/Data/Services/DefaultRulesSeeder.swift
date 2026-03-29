import SwiftData
import Foundation

/// Seeds the built-in spam keyword rules on first launch.
struct DefaultRulesSeeder {

    private let repository: any SpamRuleRepository

    init(repository: any SpamRuleRepository) {
        self.repository = repository
    }

    func seedIfNeeded() async throws {
        let existing = try await repository.fetchAll()
        guard existing.isEmpty else { return }

        for (keyword, category) in AppConfiguration.defaultSpamKeywords {
            let rule = SpamRule(
                pattern: .keyword(keyword),
                category: category,
                label: keyword
            )
            try await repository.add(rule)
        }
        AppLogger.storage.info("Default spam rules seeded (\(AppConfiguration.defaultSpamKeywords.count) rules).")
    }
}
