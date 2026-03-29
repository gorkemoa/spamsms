import Foundation

/// Build-time and runtime configuration constants.
enum AppConfiguration {
    static let minimumIOSVersion = "17.0"
    static let defaultCountryCode = "+90"
    static let maxCallDirectoryEntries = 50_000

    #if DEBUG
    static let isDebug = true
    #else
    static let isDebug = false
    #endif

    /// Built-in keyword rules loaded on first launch.
    static let defaultSpamKeywords: [(String, SpamCategory)] = [
        ("bahis", .gambling),
        ("casino", .gambling),
        ("rulet", .gambling),
        ("slot", .gambling),
        ("hesabınız askıya alınmıştır", .fakeBanking),
        ("banka doğrulama", .fakeBanking),
        ("kredi kartı bilgilerinizi", .fakeBanking),
        ("kargonuz beklemede", .cargoFraud),
        ("teslimat ücreti", .cargoFraud),
        ("yatırım fırsatı", .investment),
        ("günlük kazanç", .investment),
        ("çekiliş kazandınız", .fakeCampaign),
        ("kampanyadan haberdar", .fakeCampaign),
    ]
}
