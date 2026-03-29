import Foundation

/// Normalized phone number — immutable value object.
/// Always stored and compared in E.164 format.
struct PhoneNumber: Hashable, Codable, Sendable, CustomStringConvertible {

    let normalized: String

    /// Creates a PhoneNumber from a raw string. Returns `nil` if the number cannot be normalized.
    init?(raw: String, normalizer: PhoneNumberNormalizer = PhoneNumberNormalizer()) {
        guard let e164 = normalizer.normalize(raw) else { return nil }
        self.normalized = e164
    }

    /// For internal use when the value is already normalized.
    init(alreadyNormalized normalized: String) {
        self.normalized = normalized
    }

    var description: String { AppLogger.masked(normalized) }
}
