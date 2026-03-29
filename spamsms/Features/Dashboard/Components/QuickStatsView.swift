import SwiftUI

struct QuickStatRow: View {

    let icon: String
    let label: String
    let value: String
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(color)
                .frame(width: 24)

            Text(label)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Spacer()

            Text(value)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
        }
    }
}

struct QuickStatsView: View {

    let status: ProtectionStatus

    var body: some View {
        VStack(spacing: 0) {
            QuickStatRow(
                icon: "phone.down.fill",
                label: "dashboard.stat.blocked_numbers".localized(),
                value: "\(status.blockedNumberCount)",
                color: .red
            )
            Divider().padding(.vertical, 10)
            QuickStatRow(
                icon: "list.bullet.rectangle.fill",
                label: "dashboard.stat.active_rules".localized(),
                value: "\(status.activeRuleCount)",
                color: .orange
            )
        }
        .padding()
        .background(.secondarySystemGroupedBackground, in: RoundedRectangle(cornerRadius: 14))
    }
}
