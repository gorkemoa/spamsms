import Foundation

/// Taxonomy of spam categories identified by the rule engine.
enum SpamCategory: String, CaseIterable, Codable, Sendable, Identifiable {
    case gambling           = "gambling"
    case fakeBanking        = "fake_banking"
    case cargoFraud         = "cargo_fraud"
    case investment         = "investment"
    case adultContent       = "adult_content"
    case fakeCampaign       = "fake_campaign"
    case custom             = "custom"

    var id: String { rawValue }

    var localizedTitle: String {
        switch self {
        case .gambling:      return "spam.category.gambling".localized()
        case .fakeBanking:   return "spam.category.fake_banking".localized()
        case .cargoFraud:    return "spam.category.cargo_fraud".localized()
        case .investment:    return "spam.category.investment".localized()
        case .adultContent:  return "spam.category.adult_content".localized()
        case .fakeCampaign:  return "spam.category.fake_campaign".localized()
        case .custom:        return "spam.category.custom".localized()
        }
    }

    var systemImageName: String {
        switch self {
        case .gambling:     return "suit.club.fill"
        case .fakeBanking:  return "creditcard.trianglebadge.exclamationmark"
        case .cargoFraud:   return "shippingbox.fill"
        case .investment:   return "chart.line.uptrend.xyaxis"
        case .adultContent: return "eye.slash.fill"
        case .fakeCampaign: return "tag.slash.fill"
        case .custom:       return "slider.horizontal.3"
        }
    }
}
