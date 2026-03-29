import Foundation

@MainActor
final class RulesViewModel: ObservableObject {

    @Published private(set) var rules: [SpamRule] = []
    @Published private(set) var isLoading = false
    @Published var errorMessage: String? = nil

    private let useCase: ManageSpamRulesUseCase

    init(useCase: ManageSpamRulesUseCase) {
        self.useCase = useCase
    }

    func onAppear() async {
        await loadRules()
    }

    func loadRules() async {
        isLoading = true
        defer { isLoading = false }
        do {
            rules = try await useCase.fetchAll()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func addKeywordRule(keyword: String, category: SpamCategory, label: String) async {
        let finalLabel = label.isEmpty ? keyword : label
        do {
            try await useCase.add(pattern: .keyword(keyword), category: category, label: finalLabel)
            await loadRules()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func addRegexRule(pattern: String, category: SpamCategory, label: String) async {
        do {
            try await useCase.add(pattern: .regex(pattern), category: category, label: label)
            await loadRules()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func toggle(id: UUID, isEnabled: Bool) async {
        do {
            try await useCase.toggle(id: id, isEnabled: isEnabled, in: rules)
            if let index = rules.firstIndex(where: { $0.id == id }) {
                rules[index].isEnabled = isEnabled
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func remove(id: UUID) async {
        do {
            try await useCase.remove(id: id)
            rules.removeAll { $0.id == id }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    var groupedRules: [(SpamCategory, [SpamRule])] {
        let grouped = Dictionary(grouping: rules, by: { $0.category })
        return SpamCategory.allCases
            .compactMap { category in
                guard let categoryRules = grouped[category], !categoryRules.isEmpty else { return nil }
                return (category, categoryRules)
            }
    }
}
