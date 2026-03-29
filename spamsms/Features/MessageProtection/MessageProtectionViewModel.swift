import Foundation

@MainActor
final class MessageProtectionViewModel: ObservableObject {

    @Published private(set) var isEnabled: Bool = false
    @Published private(set) var activeRuleCount: Int = 0
    @Published private(set) var sensitivityLevel: SensitivityLevel = .medium
    @Published private(set) var isLoading = false
    @Published var errorMessage: String? = nil

    private let settingsRepository: any SettingsRepository
    private let spamRuleRepository: any SpamRuleRepository

    init(
        settingsRepository: any SettingsRepository,
        spamRuleRepository: any SpamRuleRepository
    ) {
        self.settingsRepository = settingsRepository
        self.spamRuleRepository = spamRuleRepository
    }

    func onAppear() async {
        await refresh()
    }

    func refresh() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let settings = await settingsRepository.load()
            isEnabled = settings.isMessageFilterEnabled
            sensitivityLevel = settings.sensitivityLevel
            let rules = try await spamRuleRepository.fetchEnabled()
            activeRuleCount = rules.count
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func toggleFilter(_ value: Bool) async {
        do {
            var settings = await settingsRepository.load()
            settings.isMessageFilterEnabled = value
            try await settingsRepository.save(settings)
            isEnabled = value
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func updateSensitivity(_ level: SensitivityLevel) async {
        do {
            var settings = await settingsRepository.load()
            settings.sensitivityLevel = level
            try await settingsRepository.save(settings)
            sensitivityLevel = level
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
