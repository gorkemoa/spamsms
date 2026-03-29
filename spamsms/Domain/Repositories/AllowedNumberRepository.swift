import Foundation

protocol AllowedNumberRepository: Sendable {
    func fetchAll() async throws -> [AllowedNumber]
    func add(_ number: AllowedNumber) async throws
    func delete(id: UUID) async throws
    func contains(phoneNumber: PhoneNumber) async throws -> Bool
}
