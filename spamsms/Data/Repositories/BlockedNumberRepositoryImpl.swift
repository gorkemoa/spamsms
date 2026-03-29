import SwiftData
import Foundation

final class BlockedNumberRepositoryImpl: BlockedNumberRepository {

    private let container: ModelContainer

    init(container: ModelContainer) {
        self.container = container
    }

    @MainActor
    func fetchAll() async throws -> [BlockedNumber] {
        let context = container.mainContext
        let descriptor = FetchDescriptor<PersistedBlockedNumber>(
            sortBy: [SortDescriptor(\.blockedAt, order: .reverse)]
        )
        let persisted = try context.fetch(descriptor)
        return persisted.compactMap { BlockedNumberMapper.toDomain($0) }
    }

    @MainActor
    func add(_ number: BlockedNumber) async throws {
        let context = container.mainContext
        let persisted = BlockedNumberMapper.toPersisted(number)
        context.insert(persisted)
        try context.save()
        try await syncToAppGroup()
        AppLogger.storage.info("Blocked number added: \(AppLogger.masked(number.phoneNumber.normalized))")
    }

    @MainActor
    func update(_ number: BlockedNumber) async throws {
        let context = container.mainContext
        let id = number.id
        var descriptor = FetchDescriptor<PersistedBlockedNumber>(
            predicate: #Predicate { $0.id == id }
        )
        descriptor.fetchLimit = 1
        guard let persisted = try context.fetch(descriptor).first else { return }
        persisted.label = number.label
        persisted.categoryRawValue = number.category.rawValue
        try context.save()
    }

    @MainActor
    func delete(id: UUID) async throws {
        let context = container.mainContext
        var descriptor = FetchDescriptor<PersistedBlockedNumber>(
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
    func contains(phoneNumber: PhoneNumber) async throws -> Bool {
        let context = container.mainContext
        let normalized = phoneNumber.normalized
        let descriptor = FetchDescriptor<PersistedBlockedNumber>(
            predicate: #Predicate { $0.normalizedNumber == normalized }
        )
        return try context.fetchCount(descriptor) > 0
    }

    @MainActor
    private func syncToAppGroup() async throws {
        let all = try await fetchAll()
        let shared = all.map { SharedBlockedNumber(from: $0) }
        try await SharedDataStore.shared.saveBlockedNumbers(shared)
    }
}
