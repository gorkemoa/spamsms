import SwiftUI

/// Main tab bar — the primary navigation shell after onboarding.
struct MainTabView: View {

    @EnvironmentObject private var container: DependencyContainer
    @EnvironmentObject private var router: AppRouter

    var body: some View {
        TabView(selection: $router.selectedTab) {

            DashboardView(viewModel: DashboardViewModel(
                blockedNumberRepository: container.blockedNumberRepository,
                spamRuleRepository: container.spamRuleRepository,
                protectionEventRepository: container.protectionEventRepository,
                settingsRepository: container.settingsRepository
            ))
            .tabItem { tabLabel(for: .dashboard) }
            .tag(AppRouter.MainTab.dashboard)

            BlockListView(viewModel: BlockListViewModel(useCase: container.manageBlockList))
                .tabItem { tabLabel(for: .blockList) }
                .tag(AppRouter.MainTab.blockList)

            RulesView(viewModel: RulesViewModel(useCase: container.manageSpamRules))
                .tabItem { tabLabel(for: .rules) }
                .tag(AppRouter.MainTab.rules)

            HistoryView(viewModel: HistoryViewModel(repository: container.protectionEventRepository))
                .tabItem { tabLabel(for: .history) }
                .tag(AppRouter.MainTab.history)

            SettingsView(
                viewModel: SettingsViewModel(
                    settingsRepository: container.settingsRepository,
                    protectionEventRepository: container.protectionEventRepository,
                    blockedNumberRepository: container.blockedNumberRepository,
                    allowedNumberRepository: container.allowedNumberRepository
                ),
                container: container
            )
            .tabItem { tabLabel(for: .settings) }
            .tag(AppRouter.MainTab.settings)
        }
    }

    private func tabLabel(for tab: AppRouter.MainTab) -> some View {
        Label(tab.title, systemImage: tab.systemImageName)
    }
}
