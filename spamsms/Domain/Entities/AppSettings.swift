import Foundation

/// Sensitivity level for spam evaluation.
enum SensitivityLevel: Int, CaseIterable, Codable, Sendable, Identifiable {
    case low    = 0
    case medium = 1
    case high   = 2

    var id: Int { rawValue }

    var localizedTitle: String {
        switch self {
        case .low:    return "sensitivity.low".localized()
        case .medium: return "sensitivity.medium".localized()
        case .high:   return "sensitivity.high".localized()
        }
    }
}

/// User-configurable application settings.
struct AppSettings: Codable, Sendable {
    var isCallProtectionEnabled: Bool
    var isMessageFilterEnabled: Bool
    var sensitivityLevel: SensitivityLevel
    var enabledSpamCategories: Set<SpamCategory>
    var onboardingCompleted: Bool

    static let `default` = AppSettings(
        isCallProtectionEnabled: false,
        isMessageFilterEnabled: false,
        sensitivityLevel: .medium,
        enabledSpamCategories: Set(SpamCategory.allCases.filter { $0 != .custom }),
        onboardingCompleted: false
    )
}
