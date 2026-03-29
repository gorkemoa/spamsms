import OSLog

/// Centralized structured logging. Never log raw phone numbers or message content.
enum AppLogger {

    static let general      = Logger(subsystem: AppConstants.BundleID.main, category: "general")
    static let callProtect  = Logger(subsystem: AppConstants.BundleID.main, category: "call_protection")
    static let msgFilter    = Logger(subsystem: AppConstants.BundleID.main, category: "message_filter")
    static let storage      = Logger(subsystem: AppConstants.BundleID.main, category: "storage")
    static let appGroup     = Logger(subsystem: AppConstants.BundleID.main, category: "app_group")

    /// Returns a masked version of a phone number: only the last 4 digits visible.
    static func masked(_ number: String) -> String {
        let digits = number.filter(\.isNumber)
        guard digits.count > 4 else { return "****" }
        return "****\(digits.suffix(4))"
    }
}
