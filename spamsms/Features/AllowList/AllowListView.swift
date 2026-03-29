import SwiftUI

struct AllowListView: View {

    @StateObject private var viewModel: AllowListViewModel
    @State private var showAddSheet = false

    init(viewModel: AllowListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.filteredNumbers.isEmpty && !viewModel.isLoading {
                    emptyStateView
                } else {
                    List {
                        ForEach(viewModel.filteredNumbers) { number in
                            AllowedNumberRow(number: number) {
                                Task { await viewModel.remove(id: number.id) }
                            }
                        }
                    }
                }
            }
            .navigationTitle("allow_list.title".localized())
            .searchable(text: $viewModel.searchText, prompt: "allow_list.search.prompt".localized())
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button { showAddSheet = true } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddSheet) {
                AddAllowedNumberView { raw, label in
                    await viewModel.allow(raw: raw, label: label)
                }
            }
            .alert("error.title".localized(), isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )) {
                Button("error.ok".localized(), role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
        .task { await viewModel.onAppear() }
    }

    private var emptyStateView: some View {
        ContentUnavailableView(
            "allow_list.empty.title".localized(),
            systemImage: "checkmark.shield.fill",
            description: Text("allow_list.empty.description".localized())
        )
    }
}

private struct AllowedNumberRow: View {

    let number: AllowedNumber
    let onDelete: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(.green)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 2) {
                Text(number.label.isEmpty ? "allow_list.trusted_number".localized() : number.label)
                    .font(.subheadline.weight(.medium))

                Text(AppLogger.masked(number.phoneNumber.normalized))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive, action: onDelete) {
                Label("allow_list.remove".localized(), systemImage: "trash")
            }
        }
    }
}

private struct AddAllowedNumberView: View {

    @Environment(\.dismiss) private var dismiss
    @State private var rawNumber = ""
    @State private var label = ""
    @State private var isSubmitting = false

    let onAdd: (String, String) async -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("allow_list.add.number.section".localized()) {
                    TextField("allow_list.add.number.placeholder".localized(), text: $rawNumber)
                        .keyboardType(.phonePad)
                        .autocorrectionDisabled()
                }
                Section("allow_list.add.label.section".localized()) {
                    TextField("allow_list.add.label.placeholder".localized(), text: $label)
                }
            }
            .navigationTitle("allow_list.add.title".localized())
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
                            await onAdd(rawNumber, label)
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
