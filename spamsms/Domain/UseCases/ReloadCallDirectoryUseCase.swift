import CallKit
import Foundation

/// Triggers a Call Directory Extension reload when the blocked-number list changes.
struct ReloadCallDirectoryUseCase {

    func execute() async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            CXCallDirectoryManager.sharedInstance.reloadExtension(
                withIdentifier: AppConstants.BundleID.callDirectoryExtension
            ) { error in
                if let error {
                    AppLogger.callProtect.error("Call Directory reload failed: \(error.localizedDescription)")
                    continuation.resume(throwing: error)
                } else {
                    AppLogger.callProtect.info("Call Directory reloaded successfully.")
                    continuation.resume()
                }
            }
        }
    }
}
