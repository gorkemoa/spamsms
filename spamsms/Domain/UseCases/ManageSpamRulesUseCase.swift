import Foundation

struct ManageSpamRulesUseCase {

    private let repository: any SpamRuleRepository

    init(repository: any SpamRuleRepository) {
        self.repository = repository
    }

    func fetchAll() async throws -> [SpamRule] {
        try await repository.fetchAll()
    }

    func add(pattern: MessagePattern, category: SpamCategory, label: String) async throws {
        guard !label.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw SpamRuleError.emptyLabel
        }
        let rule = SpamRule(pattern: pattern, category: category, label: label)
        try await repository.add(rule)
    }

    func toggle(id: UUID, isEnabled: Bool, in rules: [SpamRule]) async throws {
        guard var rule = rules.first(where: { $0.id == id }) else { return }
        rule.isEnabled = isEnabled
        rule.updatedAt = Date()
        try await repository.update(rule)
    }

    func remove(id: UUID) async throws {
        try await repository.delete(id: id)
    }
}

enum SpamRuleError: LocalizedError {
    case emptyLabel

    var errorDescription: String? {
        switch self {
        case .emptyLabel: return "error.rule_empty_label".localized()
        }
    }
}
