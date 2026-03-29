import SwiftUI

/// Top-level navigation destinations in the app.
enum AppRoute: Hashable {
    case dashboard
    case callProtection
    case messageProtection
    case blockList
    case allowList
    case rules
    case history
    case settings
    case onboarding
}

/// Manages navigation state for the app's main tab structure.
@MainActor
final class AppRouter: ObservableObject {

    @Published var selectedTab: MainTab = .dashboard
    @Published var showOnboarding: Bool = false

    enum MainTab: Int, CaseIterable, Identifiable {
        case dashboard
        case blockList
        case rules
        case history
        case settings

        var id: Int { rawValue }

        var title: String {
            switch self {
            case .dashboard:  return "tab.dashboard".localized()
            case .blockList:  return "tab.block_list".localized()
            case .rules:      return "tab.rules".localized()
            case .history:    return "tab.history".localized()
            case .settings:   return "tab.settings".localized()
            }
        }

        var systemImageName: String {
            switch self {
            case .dashboard:  return "shield.fill"
            case .blockList:  return "phone.down.fill"
            case .rules:      return "list.bullet.rectangle.fill"
            case .history:    return "clock.fill"
            case .settings:   return "gearshape.fill"
            }
        }
    }
}
