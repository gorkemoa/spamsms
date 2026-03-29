import Foundation

@MainActor
final class AllowListViewModel: ObservableObject {

    @Published private(set) var allowedNumbers: [AllowedNumber] = []
    @Published private(set) var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var searchText: String = ""

    private let useCase: ManageAllowListUseCase

    init(useCase: ManageAllowListUseCase) {
        self.useCase = useCase
    }

    var filteredNumbers: [AllowedNumber] {
        guard !searchText.isEmpty else { return allowedNumbers }
        return allowedNumbers.filter { number in
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
            allowedNumbers = try await useCase.fetchAll()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func allow(raw: String, label: String) async {
        do {
            try await useCase.allow(raw: raw, label: label)
            await loadNumbers()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func remove(id: UUID) async {
        do {
            try await useCase.remove(id: id)
            allowedNumbers.removeAll { $0.id == id }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
