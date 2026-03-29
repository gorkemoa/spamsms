import Foundation

protocol ProtectionEventRepository: Sendable {
    func fetchRecent(limit: Int) async throws -> [ProtectionEvent]
    func record(_ event: ProtectionEvent) async throws
    func deleteAll() async throws
}
