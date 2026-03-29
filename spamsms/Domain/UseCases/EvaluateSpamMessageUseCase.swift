import Foundation

/// Evaluates a message against the rule engine, respecting the allow list and sensitivity level.
struct EvaluateSpamMessageUseCase {

    private let allowedNumberRepository: any AllowedNumberRepository
    private let spamRuleRepository: any SpamRuleRepository

    init(
        allowedNumberRepository: any AllowedNumberRepository,
        spamRuleRepository: any SpamRuleRepository
    ) {
        self.allowedNumberRepository = allowedNumberRepository
        self.spamRuleRepository = spamRuleRepository
    }

    func execute(
        messageBody: String,
        sender: String?,
        sensitivity: SensitivityLevel
    ) async throws -> FilterDecision {

        // Allow-list check takes priority
        if let sender, !sender.isEmpty {
            let normalizer = NormalizePhoneNumberUseCase()
            if let phone = normalizer.execute(raw: sender) {
                let isAllowed = try await allowedNumberRepository.contains(phoneNumber: phone)
                if isAllowed {
                    return .allow(reason: "sender_in_allowlist")
                }
            }
        }

        let rules = try await spamRuleRepository.fetchEnabled()
        let matchingRules = rules.filter { $0.pattern.matches(messageBody) }

        guard !matchingRules.isEmpty else { return .noMatch }

        // High sensitivity: block on any match
        // Medium: require at least one match (already satisfied)
        // Low: require 2+ matches
        let requiredMatches: Int
        switch sensitivity {
        case .high:   requiredMatches = 1
        case .medium: requiredMatches = 1
        case .low:    requiredMatches = 2
        }

        guard matchingRules.count >= requiredMatches else { return .noMatch }

        let topRule = matchingRules.first!
        return .block(
            reason: "rule_match:\(topRule.label)",
            category: topRule.category
        )
    }
}
