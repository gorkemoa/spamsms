import SwiftData
import Foundation

final class ProtectionEventRepositoryImpl: ProtectionEventRepository {

    private let container: ModelContainer

    init(container: ModelContainer) {
        self.container = container
    }

    @MainActor
    func fetchRecent(limit: Int) async throws -> [ProtectionEvent] {
        let context = container.mainContext
        var descriptor = FetchDescriptor<PersistedProtectionEvent>(
            sortBy: [SortDescriptor(\.occurredAt, order: .reverse)]
        )
        descriptor.fetchLimit = limit
        return try context.fetch(descriptor).compactMap { ProtectionEventMapper.toDomain($0) }
    }

    @MainActor
    func record(_ event: ProtectionEvent) async throws {
        let context = container.mainContext
        let persisted = ProtectionEventMapper.toPersisted(event)
        context.insert(persisted)
        try context.save()
        try await pruneIfNeeded(context: context)
    }

    @MainActor
    func deleteAll() async throws {
        let context = container.mainContext
        try context.delete(model: PersistedProtectionEvent.self)
        try context.save()
    }

    @MainActor
    private func pruneIfNeeded(context: ModelContext) async throws {
        let count = try context.fetchCount(FetchDescriptor<PersistedProtectionEvent>())
        guard count > AppConstants.Limits.maxHistoryEntries else { return }

        var descriptor = FetchDescriptor<PersistedProtectionEvent>(
            sortBy: [SortDescriptor(\.occurredAt, order: .forward)]
        )
        descriptor.fetchLimit = count - AppConstants.Limits.maxHistoryEntries
        let toDelete = try context.fetch(descriptor)
        toDelete.forEach { context.delete($0) }
        try context.save()
    }
}
