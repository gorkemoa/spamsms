import IdentityLookup
import Foundation

/// Message Filter Extension entry point.
/// Evaluates incoming SMS messages against rules stored in the shared App Group container.
///
/// To add this extension to the project:
/// 1. In Xcode: File → New → Target → Message Filter Extension
/// 2. Name it "MessageFilterExtension"
/// 3. Set the bundle ID to: com.spamshield.MessageFilterExtension
/// 4. Enable the App Group capability: group.com.spamshield.shared
/// 5. Add this file to the extension target (remove from the main app target)
@available(iOS 16.0, *)
class MessageFilterExtension: ILMessageFilterExtension {}

@available(iOS 16.0, *)
extension MessageFilterExtension: ILMessageFilterQueryHandling {

    func handle(
        _ queryRequest: ILMessageFilterQueryRequest,
        context: ILMessageFilterExtensionContext,
        completion: @escaping (ILMessageFilterQueryResponse) -> Void
    ) {
        let response = ILMessageFilterQueryResponse()

        guard let messageBody = queryRequest.messageBody, !messageBody.isEmpty else {
            response.action = .none
            completion(response)
            return
        }

        let sender = queryRequest.sender

        // Load rules and allowed numbers from App Group
        let store = SharedDataStore.shared
        let sem = DispatchSemaphore(value: 0)
        var sharedRules: [SharedSpamRule] = []
        var sharedBlocked: [SharedBlockedNumber] = []

        Task {
            sharedRules = (try? await store.loadSpamRules()) ?? []
            sharedBlocked = (try? await store.loadBlockedNumbers()) ?? []
            sem.signal()
        }
        sem.wait()

        let enabledRules = sharedRules.filter(\.isEnabled)

        // Sender allow-list: if sender normalizes to a blocked entry that the user trusts — it's already handled
        // For simplicity in the extension, we check the raw sender against loaded allowed numbers
        if let sender, isAllowedSender(sender, blocked: sharedBlocked) {
            response.action = .none
            completion(response)
            return
        }

        for rule in enabledRules where rule.messagePattern.matches(messageBody) {
            response.action = .filter
            completion(response)
            return
        }

        response.action = .none
        completion(response)
    }

    private func isAllowedSender(_ sender: String, blocked: [SharedBlockedNumber]) -> Bool {
        // Extension does not have access to the allow-list in this minimal implementation.
        // Full implementation would load SharedAllowedNumber list from App Group.
        false
    }
}
