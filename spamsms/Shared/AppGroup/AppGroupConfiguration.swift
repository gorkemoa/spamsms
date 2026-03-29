import Foundation

/// Central definition of the App Group configuration shared between app and extensions.
enum AppGroupConfiguration {
    static let identifier = AppConstants.AppGroup.identifier

    static var sharedContainerURL: URL? {
        FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: identifier)
    }
}
