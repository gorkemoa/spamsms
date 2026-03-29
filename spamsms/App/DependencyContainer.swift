import SwiftData
import Foundation

/// Assembles and owns all service/repository objects for the lifetime of the app.
@MainActor
final class DependencyContainer: ObservableObject {

    // MARK: - Infrastructure
    let modelContainer: ModelContainer

    // MARK: - Repositories
    let blockedNumberRepository: any BlockedNumberRepository
    let allowedNumberRepository: any AllowedNumberRepository
    let spamRuleRepository: any SpamRuleRepository
    let protectionEventRepository: any ProtectionEventRepository
    let settingsRepository: any SettingsRepository

    // MARK: - Use Cases (stateless, created on demand via factories)
    var normalizePhoneNumber: NormalizePhoneNumberUseCase { NormalizePhoneNumberUseCase() }

    var manageBlockList: ManageBlockListUseCase {
        ManageBlockListUseCase(
            blockedNumberRepository: blockedNumberRepository,
            allowedNumberRepository: allowedNumberRepository
        )
    }

    var manageAllowList: ManageAllowListUseCase {
        ManageAllowListUseCase(
            allowedNumberRepository: allowedNumberRepository,
            blockedNumberRepository: blockedNumberRepository
        )
    }

    var manageSpamRules: ManageSpamRulesUseCase {
        ManageSpamRulesUseCase(repository: spamRuleRepository)
    }

    var evaluateSpamMessage: EvaluateSpamMessageUseCase {
        EvaluateSpamMessageUseCase(
            allowedNumberRepository: allowedNumberRepository,
            spamRuleRepository: spamRuleRepository
        )
    }

    // MARK: - Init

    init() {
        let stack = SwiftDataStack.shared
        self.modelContainer = stack.container

        self.blockedNumberRepository = BlockedNumberRepositoryImpl(container: stack.container)
        self.allowedNumberRepository = AllowedNumberRepositoryImpl(container: stack.container)
        self.spamRuleRepository = SpamRuleRepositoryImpl(container: stack.container)
        self.protectionEventRepository = ProtectionEventRepositoryImpl(container: stack.container)
        self.settingsRepository = SettingsRepositoryImpl()
    }

    /// Must be called once after launch to seed default data.
    func bootstrap() async {
        do {
            let seeder = DefaultRulesSeeder(repository: spamRuleRepository)
            try await seeder.seedIfNeeded()
        } catch {
            AppLogger.general.error("Bootstrap error: \(error.localizedDescription)")
        }
    }
}
