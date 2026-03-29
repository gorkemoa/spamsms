import Foundation

/// Normalizes raw phone number strings to E.164 format.
struct PhoneNumberNormalizer {

    private let defaultCountryCode: String

    init(defaultCountryCode: String = "+90") {
        self.defaultCountryCode = defaultCountryCode
    }

    /// Attempts to normalize `raw` to E.164. Returns `nil` if the input is invalid.
    func normalize(_ raw: String) -> String? {
        let stripped = raw.strippedPhoneFormatting
        guard stripped.looksLikePhoneNumber else { return nil }

        if stripped.hasPrefix("+") {
            return stripped
        }

        // Turkish local format: 0XXXXXXXXXX → +90XXXXXXXXXX
        if stripped.hasPrefix("0") && stripped.count == 11 {
            return defaultCountryCode + stripped.dropFirst()
        }

        // Already a national number without leading 0 → prepend default code
        if stripped.count == 10 {
            return defaultCountryCode + stripped
        }

        // Fallback: prepend default country code
        return defaultCountryCode + stripped
    }
}
