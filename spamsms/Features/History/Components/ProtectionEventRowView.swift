import SwiftUI

struct ProtectionEventRowView: View {

    let event: ProtectionEvent

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(verdictColor.opacity(0.12))
                    .frame(width: 36, height: 36)
                Image(systemName: event.type.systemImageName)
                    .foregroundStyle(verdictColor)
                    .font(.system(size: 15, weight: .semibold))
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(event.type.localizedTitle)
                    .font(.subheadline.weight(.medium))

                Text(event.maskedIdentifier)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                if let category = event.decision.triggeringCategory {
                    Text(category.localizedTitle)
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 3) {
                Text(event.occurredAt, style: .time)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)

                Text(event.occurredAt, style: .date)
                    .font(.caption2)
                    .foregroundStyle(.tertiary)
            }
        }
        .padding(.vertical, 2)
    }

    private var verdictColor: Color {
        event.decision.verdict == .block ? .red : .blue
    }
}
