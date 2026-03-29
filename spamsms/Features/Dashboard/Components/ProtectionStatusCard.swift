import SwiftUI

struct ProtectionStatusCard: View {

    let status: ProtectionStatus

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: status.overallProtectionLevel.systemImageName)
                .font(.system(size: 36, weight: .semibold))
                .foregroundStyle(levelColor)
                .frame(width: 52)

            VStack(alignment: .leading, spacing: 4) {
                Text(status.overallProtectionLevel.localizedTitle)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Text(subtitleText)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding()
        .background(levelColor.opacity(0.1), in: RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(levelColor.opacity(0.25), lineWidth: 1)
        )
    }

    private var levelColor: Color {
        switch status.overallProtectionLevel {
        case .full:     return .green
        case .callOnly: return .blue
        case .smsOnly:  return .blue
        case .off:      return .secondary
        }
    }

    private var subtitleText: String {
        let calls = status.isCallProtectionEnabled
            ? "dashboard.call_protection.on".localized()
            : "dashboard.call_protection.off".localized()
        let sms = status.isMessageFilterEnabled
            ? "dashboard.sms_filter.on".localized()
            : "dashboard.sms_filter.off".localized()
        return "\(calls) · \(sms)"
    }
}
