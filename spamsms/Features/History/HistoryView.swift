import SwiftUI

struct HistoryView: View {

    @StateObject private var viewModel: HistoryViewModel

    init(viewModel: HistoryViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.events.isEmpty && !viewModel.isLoading {
                    emptyStateView
                } else {
                    List {
                        ForEach(viewModel.events) { event in
                            ProtectionEventRowView(event: event)
                        }
                    }
                }
            }
            .navigationTitle("history.title".localized())
            .toolbar {
                if !viewModel.events.isEmpty {
                    ToolbarItem(placement: .destructiveAction) {
                        Button("history.clear_all".localized(), role: .destructive) {
                            viewModel.showClearConfirmation = true
                        }
                    }
                }
            }
            .confirmationDialog(
                "history.clear_confirm.title".localized(),
                isPresented: $viewModel.showClearConfirmation,
                titleVisibility: .visible
            ) {
                Button("history.clear_all".localized(), role: .destructive) {
                    Task { await viewModel.clearAll() }
                }
                Button("common.cancel".localized(), role: .cancel) {}
            } message: {
                Text("history.clear_confirm.message".localized())
            }
            .alert("error.title".localized(), isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )) {
                Button("error.ok".localized(), role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
            .refreshable { await viewModel.loadEvents() }
        }
        .task { await viewModel.onAppear() }
    }

    private var emptyStateView: some View {
        ContentUnavailableView(
            "history.empty.title".localized(),
            systemImage: "clock",
            description: Text("history.empty.description".localized())
        )
    }
}
