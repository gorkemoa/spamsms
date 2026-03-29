import Foundation

struct ManageBlockListUseCase {

    private let blockedNumberRepository: any BlockedNumberRepository
    private let allowedNumberRepository: any AllowedNumberRepository
    private let reloadCallDirectory: ReloadCallDirectoryUseCase
    private let normalize: NormalizePhoneNumberUseCase

    init(
        blockedNumberRepository: any BlockedNumberRepository,
        allowedNumberRepository: any AllowedNumberRepository,
        reloadCallDirectory: ReloadCallDirectoryUseCase = ReloadCallDirectoryUseCase(),
        normalize: NormalizePhoneNumberUseCase = NormalizePhoneNumberUseCase()
    ) {
        self.blockedNumberRepository = blockedNumberRepository
        self.allowedNumberRepository = allowedNumberRepository
        self.reloadCallDirectory = reloadCallDirectory
        self.normalize = normalize
    }

    func fetchAll() async throws -> [BlockedNumber] {
        try await blockedNumberRepository.fetchAll()
    }

    func block(raw: String, label: String, category: SpamCategory) async throws {
        guard let phone = normalize.execute(raw: raw) else {
            throw BlockListError.invalidNumber
        }
        let already = try await blockedNumberRepository.contains(phoneNumber: phone)
        guard !already else { throw BlockListError.alreadyBlocked }

        // Remove from allow list if present
        if try await allowedNumberRepository.contains(phoneNumber: phone) {
            let allowed = try await allowedNumberRepository.fetchAll()
            if let entry = allowed.first(where: { $0.phoneNumber == phone }) {
                try await allowedNumberRepository.delete(id: entry.id)
            }
        }

        let entry = BlockedNumber(phoneNumber: phone, label: label, category: category)
        try await blockedNumberRepository.add(entry)
        try? await reloadCallDirectory.execute()
    }

    func remove(id: UUID) async throws {
        try await blockedNumberRepository.delete(id: id)
        try? await reloadCallDirectory.execute()
    }
}

enum BlockListError: LocalizedError {
    case invalidNumber
    case alreadyBlocked

    var errorDescription: String? {
        switch self {
        case .invalidNumber:  return "error.invalid_number".localized()
        case .alreadyBlocked: return "error.already_blocked".localized()
        }
    }
}
