import Foundation

/// Aggregated protection state for the app dashboard.
struct ProtectionStatus: Equatable, Sendable {
    var isCallProtectionEnabled: Bool
    var isMessageFilterEnabled: Bool
    var blockedNumberCount: Int
    var activeRuleCount: Int
    var callDirectoryIsActive: Bool

    static let inactive = ProtectionStatus(
        isCallProtectionEnabled: false,
        isMessageFilterEnabled: false,
        blockedNumberCount: 0,
        activeRuleCount: 0,
        callDirectoryIsActive: false
    )

    var overallProtectionLevel: ProtectionLevel {
        switch (isCallProtectionEnabled, isMessageFilterEnabled) {
        case (true, true):   return .full
        case (true, false):  return .callOnly
        case (false, true):  return .smsOnly
        case (false, false): return .off
        }
    }
}

enum ProtectionLevel: String, Sendable {
    case full      = "protection.level.full"
    case callOnly  = "protection.level.call_only"
    case smsOnly   = "protection.level.sms_only"
    case off       = "protection.level.off"

    var localizedTitle: String { rawValue.localized() }

    var systemImageName: String {
        switch self {
        case .full:     return "shield.fill"
        case .callOnly: return "phone.fill.badge.checkmark"
        case .smsOnly:  return "message.fill"
        case .off:      return "shield.slash.fill"
        }
    }
}
