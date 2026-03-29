import SwiftUI

struct AddSpamRuleView: View {

    @Environment(\.dismiss) private var dismiss
    @State private var label = ""
    @State private var patternValue = ""
    @State private var patternType: PatternType = .keyword
    @State private var selectedCategory: SpamCategory = .custom
    @State private var isSubmitting = false

    let onAdd: (MessagePattern, SpamCategory, String) async -> Void

    enum PatternType: String, CaseIterable, Identifiable {
        case keyword = "rules.pattern_type.keyword"
        case regex   = "rules.pattern_type.regex"
        var id: String { rawValue }
        var localizedTitle: String { rawValue.localized() }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("rules.add.label.section".localized()) {
                    TextField("rules.add.label.placeholder".localized(), text: $label)
                }

                Section("rules.add.pattern.section".localized()) {
                    Picker("rules.add.pattern_type.picker".localized(), selection: $patternType) {
                        ForEach(PatternType.allCases) { type in
                            Text(type.localizedTitle).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)

                    TextField(
                        patternType == .keyword
                            ? "rules.add.keyword.placeholder".localized()
                            : "rules.add.regex.placeholder".localized(),
                        text: $patternValue
                    )
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                }

                Section("rules.add.category.section".localized()) {
                    Picker("rules.add.category.picker".localized(), selection: $selectedCategory) {
                        ForEach(SpamCategory.allCases) { cat in
                            Label(cat.localizedTitle, systemImage: cat.systemImageName).tag(cat)
                        }
                    }
                }
            }
            .navigationTitle("rules.add.title".localized())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("common.cancel".localized()) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("common.add".localized()) {
                        submit()
                    }
                    .disabled(label.isEmpty || patternValue.isEmpty || isSubmitting)
                }
            }
        }
    }

    private func submit() {
        let pattern: MessagePattern = patternType == .keyword
            ? .keyword(patternValue)
            : .regex(patternValue)
        isSubmitting = true
        Task {
            await onAdd(pattern, selectedCategory, label)
            isSubmitting = false
            dismiss()
        }
    }
}
