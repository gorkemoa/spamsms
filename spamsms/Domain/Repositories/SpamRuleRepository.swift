import Foundation

protocol SpamRuleRepository: Sendable {
    func fetchAll() async throws -> [SpamRule]
    func fetchEnabled() async throws -> [SpamRule]
    func add(_ rule: SpamRule) async throws
    func update(_ rule: SpamRule) async throws
    func delete(id: UUID) async throws
}
