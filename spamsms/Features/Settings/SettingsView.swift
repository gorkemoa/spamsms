import SwiftUI

struct SettingsView: View {

    @StateObject private var viewModel: SettingsViewModel
    @State private var showAllowList = false
    @State private var showBlockList = false
    private let container: DependencyContainer

    init(viewModel: SettingsViewModel, container: DependencyContainer) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.container = container
    }

    var body: some View {
        NavigationStack {
            Form {
                protectionSection
                sensitivitySection
                spamCategoriesSection
                listsSection
                PrivacySection()
                dangerSection
            }
            .navigationTitle("settings.title".localized())
            .alert("error.title".localized(), isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )) {
                Button("error.ok".localized(), role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
            .confirmationDialog(
                "settings.reset.confirm.title".localized(),
                isPresented: $viewModel.showResetConfirmation,
                titleVisibility: .visible
            ) {
                Button("settings.reset.confirm.action".localized(), role: .destructive) {
                    Task { await viewModel.resetAll() }
                }
                Button("common.cancel".localized(), role: .cancel) {}
            } message: {
                Text("settings.reset.confirm.message".localized())
            }
        }
        .task { await viewModel.onAppear() }
    }

    // MARK: - Sections

    private var protectionSection: some View {
        Section("settings.protection.section".localized()) {
            Toggle(isOn: Binding(
                get: { viewModel.settings.isCallProtectionEnabled },
                set: { value in Task { await viewModel.update(\.isCallProtectionEnabled, value: value) } }
            )) {
                Label("settings.call_protection".localized(), systemImage: "phone.down.fill")
            }

            Toggle(isOn: Binding(
                get: { viewModel.settings.isMessageFilterEnabled },
                set: { value in Task { await viewModel.update(\.isMessageFilterEnabled, value: value) } }
            )) {
                Label("settings.sms_filter".localized(), systemImage: "message.badge.filled.fill")
            }
        } footer: {
            Text("settings.protection.footer".localized())
        }
    }

    private var sensitivitySection: some View {
        Section("settings.sensitivity.section".localized()) {
            Picker("settings.sensitivity.picker".localized(), selection: Binding(
                get: { viewModel.settings.sensitivityLevel },
                set: { level in Task { await viewModel.updateSensitivity(level) } }
            )) {
                ForEach(SensitivityLevel.allCases) { level in
                    Text(level.localizedTitle).tag(level)
                }
            }
            .pickerStyle(.segmented)
        } footer: {
            Text("settings.sensitivity.footer".localized())
        }
    }

    private var spamCategoriesSection: some View {
        Section("settings.categories.section".localized()) {
            ForEach(SpamCategory.allCases) { category in
                Toggle(isOn: Binding(
                    get: { viewModel.settings.enabledSpamCategories.contains(category) },
                    set: { enabled in Task { await viewModel.toggleCategory(category, enabled: enabled) } }
                )) {
                    Label(category.localizedTitle, systemImage: category.systemImageName)
                }
            }
        }
    }

    private var listsSection: some View {
        Section("settings.lists.section".localized()) {
            NavigationLink("settings.manage_block_list".localized()) {
                BlockListView(viewModel: BlockListViewModel(useCase: container.manageBlockList))
            }
            NavigationLink("settings.manage_allow_list".localized()) {
                AllowListView(viewModel: AllowListViewModel(useCase: container.manageAllowList))
            }
        }
    }

    private var dangerSection: some View {
        Section {
            Button(role: .destructive) {
                viewModel.showResetConfirmation = true
            } label: {
                Label("settings.reset_all".localized(), systemImage: "trash")
                    .foregroundStyle(.red)
            }
        } footer: {
            Text("settings.reset_all.footer".localized())
        }
    }
}
