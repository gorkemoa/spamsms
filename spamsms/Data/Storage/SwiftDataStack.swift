import SwiftData
import Foundation

/// Configures and vends the SwiftData ModelContainer for the main app.
@MainActor
final class SwiftDataStack {

    static let shared = SwiftDataStack()

    let container: ModelContainer

    private init() {
        let schema = Schema([
            PersistedBlockedNumber.self,
            PersistedAllowedNumber.self,
            PersistedSpamRule.self,
            PersistedProtectionEvent.self,
        ])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            container = try ModelContainer(for: schema, configurations: [config])
        } catch {
            AppLogger.storage.critical("Failed to create ModelContainer: \(error)")
            fatalError("SwiftData ModelContainer initialization failed: \(error)")
        }
    }
}
