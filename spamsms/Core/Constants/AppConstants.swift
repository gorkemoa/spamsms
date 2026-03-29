import Foundation

enum AppConstants {

    enum AppGroup {
        static let identifier = "group.com.spamshield.shared"
    }

    enum BundleID {
        static let main = "com.spamshield"
        static let callDirectoryExtension = "com.spamshield.CallDirectoryExtension"
        static let messageFilterExtension = "com.spamshield.MessageFilterExtension"
    }

    enum StorageKeys {
        static let blockedNumbers = "blocked_numbers"
        static let allowedNumbers = "allowed_numbers"
        static let spamRules = "spam_rules"
        static let settings = "app_settings"
        static let callDirectoryNeedsReload = "call_directory_needs_reload"
    }

    enum Limits {
        static let maxHistoryEntries = 500
        static let maxBlockedNumbers = 50_000
        static let maxAllowedNumbers = 1_000
        static let maxCustomRules = 200
    }

    enum Localization {
        static let tableName = "Localizable"
    }
}
