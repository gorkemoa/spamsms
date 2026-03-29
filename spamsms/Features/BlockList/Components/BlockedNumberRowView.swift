import SwiftUI

struct BlockedNumberRowView: View {

    let number: BlockedNumber
    let onDelete: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: number.category.systemImageName)
                .foregroundStyle(.red.opacity(0.8))
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 2) {
                Text(number.label.isEmpty ? number.category.localizedTitle : number.label)
                    .font(.subheadline.weight(.medium))

                Text(AppLogger.masked(number.phoneNumber.normalized))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(number.blockedAt, style: .date)
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive, action: onDelete) {
                Label("block_list.remove".localized(), systemImage: "trash")
            }
        }
    }
}
