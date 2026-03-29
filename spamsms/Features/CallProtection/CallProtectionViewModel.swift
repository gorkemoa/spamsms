import CallKit
import Foundation

@MainActor
final class CallProtectionViewModel: ObservableObject {

    @Published private(set) var isEnabled: Bool = false
    @Published private(set) var callDirectoryStatus: CXCallDirectoryManager.EnabledStatus = .unknown
    @Published private(set) var blockedNumberCount: Int = 0
    @Published private(set) var isLoading = false
    @Published var errorMessage: String? = nil

    private let settingsRepository: any SettingsRepository
    private let blockedNumberRepository: any BlockedNumberRepository
    private let reloadUseCase = ReloadCallDirectoryUseCase()

    init(
        settingsRepository: any SettingsRepository,
        blockedNumberRepository: any BlockedNumberRepository
    ) {
        self.settingsRepository = settingsRepository
        self.blockedNumberRepository = blockedNumberRepository
    }

    func onAppear() async {
        await refresh()
    }

    func refresh() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let settings = await settingsRepository.load()
            isEnabled = settings.isCallProtectionEnabled
            let blocked = try await blockedNumberRepository.fetchAll()
            blockedNumberCount = blocked.count
            callDirectoryStatus = await fetchCallDirectoryStatus()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func toggleProtection(_ value: Bool) async {
        do {
            var settings = await settingsRepository.load()
            settings.isCallProtectionEnabled = value
            try await settingsRepository.save(settings)
            isEnabled = value
            if value {
                try await reloadUseCase.execute()
                callDirectoryStatus = await fetchCallDirectoryStatus()
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func fetchCallDirectoryStatus() async -> CXCallDirectoryManager.EnabledStatus {
        await withCheckedContinuation { continuation in
            CXCallDirectoryManager.sharedInstance.getEnabledStatusForExtension(
                withIdentifier: AppConstants.BundleID.callDirectoryExtension
            ) { status, _ in
                continuation.resume(returning: status)
            }
        }
    }
}
