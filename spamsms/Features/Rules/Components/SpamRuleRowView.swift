import SwiftUI

struct SpamRuleRowView: View {

    let rule: SpamRule
    let onToggle: (Bool) -> Void
    let onDelete: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text(rule.label)
                    .font(.subheadline.weight(.medium))
                    .strikethrough(!rule.isEnabled, color: .secondary)

                HStack(spacing: 4) {
                    Image(systemName: patternIcon)
                        .font(.caption2)
                    Text(rule.pattern.displayValue)
                        .font(.caption)
                        .lineLimit(1)
                }
                .foregroundStyle(.secondary)
            }

            Spacer()

            Toggle("", isOn: Binding(
                get: { rule.isEnabled },
                set: { onToggle($0) }
            ))
            .labelsHidden()
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive, action: onDelete) {
                Label("rules.remove".localized(), systemImage: "trash")
            }
        }
    }

    private var patternIcon: String {
        switch rule.pattern {
        case .keyword: return "text.cursor"
        case .regex:   return "chevron.left.forwardslash.chevron.right"
        }
    }
}
