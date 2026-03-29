import SwiftUI

struct OnboardingPageView: View {

    let page: OnboardingPage

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            Image(systemName: page.systemImage)
                .font(.system(size: 72, weight: .light))
                .foregroundStyle(.tint)
                .symbolEffect(.pulse)

            VStack(spacing: 12) {
                Text(page.titleKey.localized())
                    .font(.title2.bold())
                    .multilineTextAlignment(.center)

                Text(page.bodyKey.localized())
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 8)
            }

            Spacer()
        }
        .padding(.horizontal, 24)
    }
}
