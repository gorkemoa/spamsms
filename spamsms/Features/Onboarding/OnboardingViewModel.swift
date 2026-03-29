import Foundation

@MainActor
final class OnboardingViewModel: ObservableObject {

    @Published var currentPageIndex: Int = 0
    @Published private(set) var isCompleting = false

    let pages: [OnboardingPage] = OnboardingPage.pages
    private let settingsRepository: any SettingsRepository
    var onComplete: (() -> Void)?

    init(settingsRepository: any SettingsRepository, onComplete: (() -> Void)? = nil) {
        self.settingsRepository = settingsRepository
        self.onComplete = onComplete
    }

    var isLastPage: Bool { currentPageIndex == pages.count - 1 }

    func nextPage() {
        guard !isLastPage else { return }
        currentPageIndex += 1
    }

    func complete() async {
        isCompleting = true
        defer { isCompleting = false }
        do {
            var settings = await settingsRepository.load()
            settings.onboardingCompleted = true
            try await settingsRepository.save(settings)
        } catch {
            AppLogger.general.error("Failed to persist onboarding completion: \(error)")
        }
        onComplete?()
    }
}
