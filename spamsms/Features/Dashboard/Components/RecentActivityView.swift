import SwiftUI

struct RecentActivityView: View {

    let events: [ProtectionEvent]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("dashboard.recent_activity".localized())
                .font(.headline)
                .padding(.bottom, 10)

            if events.isEmpty {
                emptyState
            } else {
                ForEach(events) { event in
                    EventRow(event: event)
                    if event.id != events.last?.id {
                        Divider().padding(.leading, 40)
                    }
                }
            }
        }
        .padding()
        .background(.secondarySystemGroupedBackground, in: RoundedRectangle(cornerRadius: 14))
    }

    private var emptyState: some View {
        HStack {
            Spacer()
            VStack(spacing: 8) {
                Image(systemName: "checkmark.shield")
                    .font(.title2)
                    .foregroundStyle(.secondary)
                Text("dashboard.no_recent_activity".localized())
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 12)
            Spacer()
        }
    }
}

private struct EventRow: View {

    let event: ProtectionEvent

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: event.type.systemImageName)
                .foregroundStyle(verdictColor)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 2) {
                Text(event.type.localizedTitle)
                    .font(.subheadline.weight(.medium))

                Text(event.maskedIdentifier)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(event.occurredAt, style: .relative)
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 6)
    }

    private var verdictColor: Color {
        event.decision.verdict == .block ? .red : .blue
    }
}
