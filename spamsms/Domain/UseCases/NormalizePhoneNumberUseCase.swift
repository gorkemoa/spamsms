import Foundation

struct NormalizePhoneNumberUseCase {
    private let normalizer: PhoneNumberNormalizer

    init(normalizer: PhoneNumberNormalizer = PhoneNumberNormalizer()) {
        self.normalizer = normalizer
    }

    /// Returns a normalized `PhoneNumber` or `nil` if the raw string is invalid.
    func execute(raw: String) -> PhoneNumber? {
        PhoneNumber(raw: raw, normalizer: normalizer)
    }
}
