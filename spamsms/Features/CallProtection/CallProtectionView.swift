import CallKit
import SwiftUI

struct CallProtectionView: View {

    @StateObject private var viewModel: CallProtectionViewModel

    init(viewModel: CallProtectionViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Toggle(isOn: Binding(
                        get: { viewModel.isEnabled },
                        set: { value in Task { await viewModel.toggleProtection(value) } }
                    )) {
                        Label("call_protection.toggle".localized(), systemImage: "phone.down.fill")
                    }
                } footer: {
                    Text("call_protection.toggle.footer".localized())
                }

                Section("call_protection.status.section".localized()) {
                    StatusRow(
                        label: "call_protection.directory_status".localized(),
                        value: callDirectoryStatusText,
                        color: callDirectoryStatusColor
                    )
                    StatusRow(
                        label: "call_protection.blocked_count".localized(),
                        value: "\(viewModel.blockedNumberCount)",
                        color: .primary
                    )
                }

                Section("call_protection.setup.section".localized()) {
                    Button {
                        openPhoneSettings()
                    } label: {
                        Label("call_protection.open_settings".localized(), systemImage: "gear")
                    }
                } footer: {
                    Text("call_protection.setup.footer".localized())
                }
            }
            .navigationTitle("call_protection.title".localized())
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

    private func openPhoneSettings() {
        guard let url = URL(string: "App-Prefs:root=Phone") else { return }
        UIApplication.shared.open(url)
    }

    private var callDirectoryStatusText: String {
        switch viewModel.callDirectoryStatus {
        case .enabled:  return "status.enabled".localized()
        case .disabled: return "status.disabled".localized()
        default:        return "status.unknown".localized()
        }
    }

    private var callDirectoryStatusColor: Color {
        switch viewModel.callDirectoryStatus {
        case .enabled:  return .green
        case .disabled: return .red
        default:        return .secondary
        }
    }
}

private struct StatusRow: View {
    let label: String
    let value: String
    let color: Color

    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Text(value).foregroundStyle(color)
        }
    }
}
