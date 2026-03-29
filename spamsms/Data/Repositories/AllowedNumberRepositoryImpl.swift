import SwiftData
import Foundation

final class AllowedNumberRepositoryImpl: AllowedNumberRepository {

    private let container: ModelContainer

    init(container: ModelContainer) {
        self.container = container
    }

    @MainActor
    func fetchAll() async throws -> [AllowedNumber] {
        let context = container.mainContext
        let descriptor = FetchDescriptor<PersistedAllowedNumber>(
            sortBy: [SortDescriptor(\.addedAt, order: .reverse)]
        )
        return try context.fetch(descriptor).map { AllowedNumberMapper.toDomain($0) }
    }

    @MainActor
    func add(_ number: AllowedNumber) async throws {
        let context = container.mainContext
        let persisted = AllowedNumberMapper.toPersisted(number)
        context.insert(persisted)
        try context.save()
    }

    @MainActor
    func delete(id: UUID) async throws {
        let context = container.mainContext
        var descriptor = FetchDescriptor<PersistedAllowedNumber>(
            predicate: #Predicate { $0.id == id }
        )
        descriptor.fetchLimit = 1
        if let persisted = try context.fetch(descriptor).first {
            context.delete(persisted)
            try context.save()
        }
    }

    @MainActor
    func contains(phoneNumber: PhoneNumber) async throws -> Bool {
        let context = container.mainContext
        let normalized = phoneNumber.normalized
        let descriptor = FetchDescriptor<PersistedAllowedNumber>(
            predicate: #Predicate { $0.normalizedNumber == normalized }
        )
        return try context.fetchCount(descriptor) > 0
    }
}
