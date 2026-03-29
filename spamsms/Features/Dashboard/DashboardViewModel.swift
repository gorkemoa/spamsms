import Foundation

@MainActor
final class DashboardViewModel: ObservableObject {

    @Published private(set) var protectionStatus: ProtectionStatus = .inactive
    @Published private(set) var recentEvents: [ProtectionEvent] = []
    @Published private(set) var isLoading = false
    @Published var errorMessage: String? = nil

    private let blockedNumberRepository: any BlockedNumberRepository
    private let spamRuleRepository: any SpamRuleRepository
    private let protectionEventRepository: any ProtectionEventRepository
    private let settingsRepository: any SettingsRepository

    init(
        blockedNumberRepository: any BlockedNumberRepository,
        spamRuleRepository: any SpamRuleRepository,
        protectionEventRepository: any ProtectionEventRepository,
        settingsRepository: any SettingsRepository
    ) {
        self.blockedNumberRepository = blockedNumberRepository
        self.spamRuleRepository = spamRuleRepository
        self.protectionEventRepository = protectionEventRepository
        self.settingsRepository = settingsRepository
    }

    func onAppear() async {
        await refresh()
    }

    func refresh() async {
        isLoading = true
        defer { isLoading = false }
        do {
            async let settings = settingsRepository.load()
            async let blockedCount = blockedNumberRepository.fetchAll()
            async let activeRules = spamRuleRepository.fetchEnabled()
            async let events = protectionEventRepository.fetchRecent(limit: 5)

            let (s, blocked, rules, ev) = try await (settings, blockedCount, activeRules, events)

            protectionStatus = ProtectionStatus(
                isCallProtectionEnabled: s.isCallProtectionEnabled,
                isMessageFilterEnabled: s.isMessageFilterEnabled,
                blockedNumberCount: blocked.count,
                activeRuleCount: rules.count,
                callDirectoryIsActive: s.isCallProtectionEnabled
            )
            recentEvents = ev
        } catch {
            errorMessage = error.localizedDescription
            AppLogger.general.error("Dashboard refresh failed: \(error.localizedDescription)")
        }
    }
}
