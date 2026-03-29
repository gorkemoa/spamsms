import Foundation

protocol BlockedNumberRepository: Sendable {
    func fetchAll() async throws -> [BlockedNumber]
    func add(_ number: BlockedNumber) async throws
    func update(_ number: BlockedNumber) async throws
    func delete(id: UUID) async throws
    func contains(phoneNumber: PhoneNumber) async throws -> Bool
}
