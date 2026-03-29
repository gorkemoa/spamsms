import Foundation

struct ManageAllowListUseCase {

    private let allowedNumberRepository: any AllowedNumberRepository
    private let blockedNumberRepository: any BlockedNumberRepository
    private let reloadCallDirectory: ReloadCallDirectoryUseCase
    private let normalize: NormalizePhoneNumberUseCase

    init(
        allowedNumberRepository: any AllowedNumberRepository,
        blockedNumberRepository: any BlockedNumberRepository,
        reloadCallDirectory: ReloadCallDirectoryUseCase = ReloadCallDirectoryUseCase(),
        normalize: NormalizePhoneNumberUseCase = NormalizePhoneNumberUseCase()
    ) {
        self.allowedNumberRepository = allowedNumberRepository
        self.blockedNumberRepository = blockedNumberRepository
        self.reloadCallDirectory = reloadCallDirectory
        self.normalize = normalize
    }

    func fetchAll() async throws -> [AllowedNumber] {
        try await allowedNumberRepository.fetchAll()
    }

    func allow(raw: String, label: String) async throws {
        guard let phone = normalize.execute(raw: raw) else {
            throw AllowListError.invalidNumber
        }
        let already = try await allowedNumberRepository.contains(phoneNumber: phone)
        guard !already else { throw AllowListError.alreadyAllowed }

        // Remove from block list if present
        if try await blockedNumberRepository.contains(phoneNumber: phone) {
            let blocked = try await blockedNumberRepository.fetchAll()
            if let entry = blocked.first(where: { $0.phoneNumber == phone }) {
                try await blockedNumberRepository.delete(id: entry.id)
            }
        }

        let entry = AllowedNumber(phoneNumber: phone, label: label)
        try await allowedNumberRepository.add(entry)
        try? await reloadCallDirectory.execute()
    }

    func remove(id: UUID) async throws {
        try await allowedNumberRepository.delete(id: id)
        try? await reloadCallDirectory.execute()
    }
}

enum AllowListError: LocalizedError {
    case invalidNumber
    case alreadyAllowed

    var errorDescription: String? {
        switch self {
        case .invalidNumber: return "error.invalid_number".localized()
        case .alreadyAllowed: return "error.already_allowed".localized()
        }
    }
}
