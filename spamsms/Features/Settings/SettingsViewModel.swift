import Foundation

@MainActor
final class SettingsViewModel: ObservableObject {

    @Published private(set) var settings: AppSettings = .default
    @Published private(set) var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var showResetConfirmation = false

    private let settingsRepository: any SettingsRepository
    private let protectionEventRepository: any ProtectionEventRepository
    private let blockedNumberRepository: any BlockedNumberRepository
    private let allowedNumberRepository: any AllowedNumberRepository

    init(
        settingsRepository: any SettingsRepository,
        protectionEventRepository: any ProtectionEventRepository,
        blockedNumberRepository: any BlockedNumberRepository,
        allowedNumberRepository: any AllowedNumberRepository
    ) {
        self.settingsRepository = settingsRepository
        self.protectionEventRepository = protectionEventRepository
        self.blockedNumberRepository = blockedNumberRepository
        self.allowedNumberRepository = allowedNumberRepository
    }

    func onAppear() async {
        settings = await settingsRepository.load()
    }

    func update(_ keyPath: WritableKeyPath<AppSettings, Bool>, value: Bool) async {
        settings[keyPath: keyPath] = value
        await persistSettings()
    }

    func updateSensitivity(_ level: SensitivityLevel) async {
        settings.sensitivityLevel = level
        await persistSettings()
    }

    func toggleCategory(_ category: SpamCategory, enabled: Bool) async {
        if enabled {
            settings.enabledSpamCategories.insert(category)
        } else {
            settings.enabledSpamCategories.remove(category)
        }
        await persistSettings()
    }

    func resetAll() async {
        do {
            try await protectionEventRepository.deleteAll()

            let blocked = try await blockedNumberRepository.fetchAll()
            for b in blocked { try await blockedNumberRepository.delete(id: b.id) }

            let allowed = try await allowedNumberRepository.fetchAll()
            for a in allowed { try await allowedNumberRepository.delete(id: a.id) }

            settings = .default
            try await settingsRepository.save(settings)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func persistSettings() async {
        do {
            try await settingsRepository.save(settings)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
