import Foundation

struct OnboardingPage: Identifiable {
    let id: Int
    let systemImage: String
    let titleKey: String
    let bodyKey: String

    static let pages: [OnboardingPage] = [
        OnboardingPage(
            id: 0,
            systemImage: "shield.lefthalf.filled",
            titleKey: "onboarding.page0.title",
            bodyKey: "onboarding.page0.body"
        ),
        OnboardingPage(
            id: 1,
            systemImage: "phone.down.fill",
            titleKey: "onboarding.page1.title",
            bodyKey: "onboarding.page1.body"
        ),
        OnboardingPage(
            id: 2,
            systemImage: "message.badge.filled.fill",
            titleKey: "onboarding.page2.title",
            bodyKey: "onboarding.page2.body"
        ),
        OnboardingPage(
            id: 3,
            systemImage: "lock.shield.fill",
            titleKey: "onboarding.page3.title",
            bodyKey: "onboarding.page3.body"
        ),
    ]
}
