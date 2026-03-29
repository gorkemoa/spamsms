import SwiftData
import Foundation

final class SpamRuleRepositoryImpl: SpamRuleRepository {

    private let container: ModelContainer

    init(container: ModelContainer) {
        self.container = container
    }

    @MainActor
    func fetchAll() async throws -> [SpamRule] {
        let context = container.mainContext
        let descriptor = FetchDescriptor<PersistedSpamRule>(
            sortBy: [SortDescriptor(\.createdAt, order: .reverse)]
        )
        return try context.fetch(descriptor).map { SpamRuleMapper.toDomain($0) }
    }

    @MainActor
    func fetchEnabled() async throws -> [SpamRule] {
        let context = container.mainContext
        let descriptor = FetchDescriptor<PersistedSpamRule>(
            predicate: #Predicate { $0.isEnabled == true }
        )
        return try context.fetch(descriptor).map { SpamRuleMapper.toDomain($0) }
    }

    @MainActor
    func add(_ rule: SpamRule) async throws {
        let context = container.mainContext
        let persisted = SpamRuleMapper.toPersisted(rule)
        context.insert(persisted)
        try context.save()
        try await syncToAppGroup()
    }

    @MainActor
    func update(_ rule: SpamRule) async throws {
        let context = container.mainContext
        let id = rule.id
        var descriptor = FetchDescriptor<PersistedSpamRule>(
            predicate: #Predicate { $0.id == id }
        )
        descriptor.fetchLimit = 1
        guard let persisted = try context.fetch(descriptor).first else { return }
        persisted.isEnabled = rule.isEnabled
        persisted.label = rule.label
        persisted.updatedAt = rule.updatedAt
        try context.save()
        try await syncToAppGroup()
    }

    @MainActor
    func delete(id: UUID) async throws {
        let context = container.mainContext
        var descriptor = FetchDescriptor<PersistedSpamRule>(
            predicate: #Predicate { $0.id == id }
        )
        descriptor.fetchLimit = 1
        if let persisted = try context.fetch(descriptor).first {
            context.delete(persisted)
            try context.save()
            try await syncToAppGroup()
        }
    }

    @MainActor
    private func syncToAppGroup() async throws {
        let all = try await fetchAll()
        let shared = all.map { SharedSpamRule(from: $0) }
        try await SharedDataStore.shared.saveSpamRules(shared)
    }
}
