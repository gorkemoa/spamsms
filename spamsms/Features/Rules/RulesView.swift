import SwiftUI

struct RulesView: View {

    @StateObject private var viewModel: RulesViewModel
    @State private var showAddSheet = false

    init(viewModel: RulesViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.rules.isEmpty && !viewModel.isLoading {
                    emptyStateView
                } else {
                    List {
                        ForEach(viewModel.groupedRules, id: \.0) { category, rules in
                            Section {
                                ForEach(rules) { rule in
                                    SpamRuleRowView(
                                        rule: rule,
                                        onToggle: { enabled in
                                            Task { await viewModel.toggle(id: rule.id, isEnabled: enabled) }
                                        },
                                        onDelete: {
                                            Task { await viewModel.remove(id: rule.id) }
                                        }
                                    )
                                }
                            } header: {
                                Label(category.localizedTitle, systemImage: category.systemImageName)
                            }
                        }
                    }
                }
            }
            .navigationTitle("rules.title".localized())
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button { showAddSheet = true } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddSheet) {
                AddSpamRuleView { pattern, category, label in
                    switch pattern {
                    case .keyword(let w):
                        await viewModel.addKeywordRule(keyword: w, category: category, label: label)
                    case .regex(let r):
                        await viewModel.addRegexRule(pattern: r, category: category, label: label)
                    }
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
            "rules.empty.title".localized(),
            systemImage: "list.bullet.rectangle.fill",
            description: Text("rules.empty.description".localized())
        )
    }
}
