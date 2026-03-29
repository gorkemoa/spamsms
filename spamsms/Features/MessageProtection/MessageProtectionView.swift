import SwiftUI

struct MessageProtectionView: View {

    @StateObject private var viewModel: MessageProtectionViewModel

    init(viewModel: MessageProtectionViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Toggle(isOn: Binding(
                        get: { viewModel.isEnabled },
                        set: { value in Task { await viewModel.toggleFilter(value) } }
                    )) {
                        Label("message_protection.toggle".localized(), systemImage: "message.badge.filled.fill")
                    }
                } footer: {
                    Text("message_protection.toggle.footer".localized())
                }

                if viewModel.isEnabled {
                    Section("message_protection.sensitivity.section".localized()) {
                        Picker(
                            "message_protection.sensitivity.picker".localized(),
                            selection: Binding(
                                get: { viewModel.sensitivityLevel },
                                set: { level in Task { await viewModel.updateSensitivity(level) } }
                            )
                        ) {
                            ForEach(SensitivityLevel.allCases) { level in
                                Text(level.localizedTitle).tag(level)
                            }
                        }
                        .pickerStyle(.segmented)
                    } footer: {
                        Text("message_protection.sensitivity.footer".localized())
                    }

                    Section("message_protection.stats.section".localized()) {
                        HStack {
                            Text("message_protection.active_rules".localized())
                            Spacer()
                            Text("\(viewModel.activeRuleCount)")
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("message_protection.title".localized())
            .refreshable { await viewModel.refresh() }
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
}
