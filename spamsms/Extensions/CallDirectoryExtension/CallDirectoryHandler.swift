import CallKit
import Foundation

/// Call Directory Extension entry point.
/// Reads blocked numbers from the shared App Group container and registers them with CallKit.
///
/// To add this extension to the project:
/// 1. In Xcode: File → New → Target → Call Directory Extension
/// 2. Name it "CallDirectoryExtension"
/// 3. Set the bundle ID to: com.spamshield.CallDirectoryExtension
/// 4. Enable the App Group capability: group.com.spamshield.shared
/// 5. Add this file to the extension target (remove from the main app target)
@available(iOS 10.0, *)
class CallDirectoryHandler: CXCallDirectoryProvider {

    override func beginRequest(with context: CXCallDirectoryExtensionContext) {
        context.delegate = self

        guard context.isIncremental else {
            loadAllBlockedNumbers(into: context)
            context.completeRequest()
            return
        }

        // Incremental reload — remove stale entries, add new ones.
        // For v1, we reload the full list on each request for simplicity.
        loadAllBlockedNumbers(into: context)
        context.completeRequest()
    }

    private func loadAllBlockedNumbers(into context: CXCallDirectoryExtensionContext) {
        do {
            let store = SharedDataStore.shared
            let numbers: [SharedBlockedNumber]
            // Actor bridging: call synchronously from the extension's background context
            let sem = DispatchSemaphore(value: 0)
            var loaded: [SharedBlockedNumber] = []
            Task {
                loaded = (try? await store.loadBlockedNumbers()) ?? []
                sem.signal()
            }
            sem.wait()
            numbers = loaded

            let sorted = numbers.sorted { $0.normalizedNumber < $1.normalizedNumber }
            for entry in sorted {
                guard let numberInt = CXCallDirectoryPhoneNumber(entry.normalizedNumber) else { continue }
                context.addBlockingEntry(withNextSequentialPhoneNumber: numberInt)
                context.addIdentificationEntry(
                    withNextSequentialPhoneNumber: numberInt,
                    label: entry.label
                )
            }
        }
    }
}

@available(iOS 10.0, *)
extension CallDirectoryHandler: CXCallDirectoryExtensionContextDelegate {
    func requestFailed(for extensionContext: CXCallDirectoryExtensionContext, withError error: Error) {
        // Log and fail gracefully — the system will retry.
    }
}

private extension CXCallDirectoryPhoneNumber {
    init?(_ e164: String) {
        let digits = e164.filter(\.isNumber)
        guard let value = Int64(digits) else { return nil }
        self = value
    }
}
