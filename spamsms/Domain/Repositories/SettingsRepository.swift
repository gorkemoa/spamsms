import Foundation

protocol SettingsRepository: Sendable {
    func load() async -> AppSettings
    func save(_ settings: AppSettings) async throws
}
