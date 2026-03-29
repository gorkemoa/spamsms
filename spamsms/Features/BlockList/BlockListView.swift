import SwiftUI

struct BlockListView: View {

    @StateObject private var viewModel: BlockListViewModel
    @State private var showAddSheet = false

    init(viewModel: BlockListViewModel) {
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
                            BlockedNumberRowView(number: number) {
                                Task { await viewModel.remove(id: number.id) }
                            }
                        }
                    }
                }
            }
            .navigationTitle("block_list.title".localized())
            .searchable(text: $viewModel.searchText, prompt: "block_list.search.prompt".localized())
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showAddSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddSheet) {
                AddBlockedNumberView { raw, label, category in
                    await viewModel.block(raw: raw, label: label, category: category)
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
            "block_list.empty.title".localized(),
            systemImage: "phone.down.fill",
            description: Text("block_list.empty.description".localized())
        )
    }
}
