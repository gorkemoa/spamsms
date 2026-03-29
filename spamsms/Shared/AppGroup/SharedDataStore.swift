import Foundation

/// Thread-safe read/write access to the JSON files in the App Group shared container.
/// Used by both the main app and extensions to exchange blocked numbers and rules.
actor SharedDataStore {

    static let shared = SharedDataStore()

    private let fileManager = FileManager.default

    private var containerURL: URL {
        get throws {
            guard let url = AppGroupConfiguration.sharedContainerURL else {
                throw SharedDataStoreError.containerUnavailable
            }
            return url
        }
    }

    // MARK: - Blocked Numbers

    func saveBlockedNumbers(_ numbers: [SharedBlockedNumber]) throws {
        let url = try containerURL.appending(path: AppConstants.StorageKeys.blockedNumbers + ".json")
        let data = try JSONEncoder().encode(numbers)
        try data.write(to: url, options: .atomic)
        AppLogger.appGroup.debug("Saved \(numbers.count) blocked numbers to App Group.")
    }

    func loadBlockedNumbers() throws -> [SharedBlockedNumber] {
        let url = try containerURL.appending(path: AppConstants.StorageKeys.blockedNumbers + ".json")
        guard fileManager.fileExists(atPath: url.path) else { return [] }
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode([SharedBlockedNumber].self, from: data)
    }

    // MARK: - Spam Rules

    func saveSpamRules(_ rules: [SharedSpamRule]) throws {
        let url = try containerURL.appending(path: AppConstants.StorageKeys.spamRules + ".json")
        let data = try JSONEncoder().encode(rules)
        try data.write(to: url, options: .atomic)
    }

    func loadSpamRules() throws -> [SharedSpamRule] {
        let url = try containerURL.appending(path: AppConstants.StorageKeys.spamRules + ".json")
        guard fileManager.fileExists(atPath: url.path) else { return [] }
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode([SharedSpamRule].self, from: data)
    }
}

enum SharedDataStoreError: LocalizedError {
    case containerUnavailable

    var errorDescription: String? {
        "App Group container is unavailable. Ensure the entitlement is configured correctly."
    }
}
