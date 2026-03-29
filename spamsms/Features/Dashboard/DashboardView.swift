import SwiftUI

struct DashboardView: View {

    @StateObject private var viewModel: DashboardViewModel
    @EnvironmentObject private var router: AppRouter

    init(viewModel: DashboardViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    ProtectionStatusCard(status: viewModel.protectionStatus)

                    QuickStatsView(status: viewModel.protectionStatus)

                    RecentActivityView(events: viewModel.recentEvents)
                }
                .padding(.horizontal)
                .padding(.top, 8)
            }
            .navigationTitle("dashboard.title".localized())
            .background(Color(.systemGroupedBackground))
            .refreshable { await viewModel.refresh() }
            .overlay {
                if viewModel.isLoading && viewModel.recentEvents.isEmpty {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.ultraThinMaterial)
                }
            }
            .alert(
                "error.title".localized(),
                isPresented: Binding(
                    get: { viewModel.errorMessage != nil },
                    set: { if !$0 { viewModel.errorMessage = nil } }
                )
            ) {
                Button("error.ok".localized(), role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
        .task { await viewModel.onAppear() }
    }
}
