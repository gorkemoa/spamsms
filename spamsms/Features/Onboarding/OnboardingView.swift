import SwiftUI

struct OnboardingView: View {

    @StateObject private var viewModel: OnboardingViewModel

    init(viewModel: OnboardingViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 24) {
            TabView(selection: $viewModel.currentPageIndex) {
                ForEach(viewModel.pages) { page in
                    OnboardingPageView(page: page)
                        .tag(page.id)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))

            PageIndicator(
                total: viewModel.pages.count,
                current: viewModel.currentPageIndex
            )

            actionButton
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
        }
        .background(Color(.systemBackground))
        .interactiveDismissDisabled()
    }

    @ViewBuilder
    private var actionButton: some View {
        if viewModel.isLastPage {
            Button {
                Task { await viewModel.complete() }
            } label: {
                Label("onboarding.get_started".localized(), systemImage: "checkmark")
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 4)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(viewModel.isCompleting)
        } else {
            Button {
                withAnimation { viewModel.nextPage() }
            } label: {
                Text("onboarding.next".localized())
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 4)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
    }
}

private struct PageIndicator: View {

    let total: Int
    let current: Int

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<total, id: \.self) { index in
                Capsule()
                    .fill(index == current ? Color.accentColor : Color.secondary.opacity(0.35))
                    .frame(width: index == current ? 20 : 6, height: 6)
                    .animation(.spring(response: 0.3), value: current)
            }
        }
    }
}
