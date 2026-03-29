import Foundation

final class SettingsRepositoryImpl: SettingsRepository {

    private let userDefaults: UserDefaults
    private let key = AppConstants.StorageKeys.settings
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func load() async -> AppSettings {
        guard
            let data = userDefaults.data(forKey: key),
            let settings = try? decoder.decode(AppSettings.self, from: data)
        else {
            return .default
        }
        return settings
    }

    func save(_ settings: AppSettings) async throws {
        let data = try encoder.encode(settings)
        userDefaults.set(data, forKey: key)
    }
}
