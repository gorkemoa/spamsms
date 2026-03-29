import SwiftUI

struct PrivacySection: View {

    var body: some View {
        Section("settings.privacy.section".localized()) {
            VStack(alignment: .leading, spacing: 10) {
                PrivacyPoint(
                    icon: "iphone",
                    text: "settings.privacy.on_device".localized()
                )
                PrivacyPoint(
                    icon: "envelope.badge.shield.half.filled",
                    text: "settings.privacy.no_upload".localized()
                )
                PrivacyPoint(
                    icon: "person.slash",
                    text: "settings.privacy.no_profiling".localized()
                )
                PrivacyPoint(
                    icon: "lock.shield",
                    text: "settings.privacy.minimal_data".localized()
                )
            }
            .padding(.vertical, 4)
        }
    }
}

private struct PrivacyPoint: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon)
                .foregroundStyle(.tint)
                .frame(width: 20)
            Text(text)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
}
