import Foundation

@MainActor
final class HistoryViewModel: ObservableObject {

    @Published private(set) var events: [ProtectionEvent] = []
    @Published private(set) var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var showClearConfirmation = false

    private let repository: any ProtectionEventRepository

    init(repository: any ProtectionEventRepository) {
        self.repository = repository
    }

    func onAppear() async {
        await loadEvents()
    }

    func loadEvents() async {
        isLoading = true
        defer { isLoading = false }
        do {
            events = try await repository.fetchRecent(limit: AppConstants.Limits.maxHistoryEntries)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func clearAll() async {
        do {
            try await repository.deleteAll()
            events = []
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
