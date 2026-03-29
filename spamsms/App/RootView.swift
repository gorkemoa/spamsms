import SwiftUI

/// Root view — shows onboarding on first launch, then the main tab bar.
struct RootView: View {

    @EnvironmentObject private var container: DependencyContainer
    @EnvironmentObject private var router: AppRouter
    @State private var settingsLoaded = false
    @State private var showOnboarding = false

    var body: some View {
        Group {
            if !settingsLoaded {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if showOnboarding {
                OnboardingView(
                    viewModel: OnboardingViewModel(
                        settingsRepository: container.settingsRepository,
                        onComplete: { showOnboarding = false }
                    )
                )
                .transition(.opacity)
            } else {
                MainTabView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: settingsLoaded)
        .animation(.easeInOut(duration: 0.3), value: showOnboarding)
        .task {
            let settings = await container.settingsRepository.load()
            showOnboarding = !settings.onboardingCompleted
            settingsLoaded = true
        }
    }
}
