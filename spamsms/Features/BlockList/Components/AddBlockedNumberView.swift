import SwiftUI

struct AddBlockedNumberView: View {

    @Environment(\.dismiss) private var dismiss
    @State private var rawNumber = ""
    @State private var label = ""
    @State private var selectedCategory: SpamCategory = .custom
    @State private var isSubmitting = false

    let onAdd: (String, String, SpamCategory) async -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("block_list.add.number.section".localized()) {
                    TextField("block_list.add.number.placeholder".localized(), text: $rawNumber)
                        .keyboardType(.phonePad)
                        .autocorrectionDisabled()
                }

                Section("block_list.add.label.section".localized()) {
                    TextField("block_list.add.label.placeholder".localized(), text: $label)
                }

                Section("block_list.add.category.section".localized()) {
                    Picker("block_list.add.category.picker".localized(), selection: $selectedCategory) {
                        ForEach(SpamCategory.allCases) { category in
                            Label(category.localizedTitle, systemImage: category.systemImageName)
                                .tag(category)
                        }
                    }
                }
            }
            .navigationTitle("block_list.add.title".localized())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("common.cancel".localized()) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("common.add".localized()) {
                        guard !rawNumber.isEmpty else { return }
                        isSubmitting = true
                        Task {
                            await onAdd(rawNumber, label, selectedCategory)
                            isSubmitting = false
                            dismiss()
                        }
                    }
                    .disabled(rawNumber.isEmpty || isSubmitting)
                }
            }
        }
    }
}
