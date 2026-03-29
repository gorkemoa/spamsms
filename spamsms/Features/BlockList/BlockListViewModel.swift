import Foundation

@MainActor
final class BlockListViewModel: ObservableObject {

    @Published private(set) var blockedNumbers: [BlockedNumber] = []
    @Published private(set) var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var searchText: String = ""

    private let useCase: ManageBlockListUseCase

    init(useCase: ManageBlockListUseCase) {
        self.useCase = useCase
    }

    var filteredNumbers: [BlockedNumber] {
        guard !searchText.isEmpty else { return blockedNumbers }
        return blockedNumbers.filter { number in
            number.phoneNumber.normalized.contains(searchText) ||
            number.label.localizedCaseInsensitiveContains(searchText)
        }
    }

    func onAppear() async {
        await loadNumbers()
    }

    func loadNumbers() async {
        isLoading = true
        defer { isLoading = false }
        do {
            blockedNumbers = try await useCase.fetchAll()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func block(raw: String, label: String, category: SpamCategory) async {
        do {
            try await useCase.block(raw: raw, label: label, category: category)
            await loadNumbers()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func remove(id: UUID) async {
        do {
            try await useCase.remove(id: id)
            blockedNumbers.removeAll { $0.id == id }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
