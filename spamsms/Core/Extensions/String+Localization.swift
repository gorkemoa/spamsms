import Foundation

extension String {

    func localized(table: String = AppConstants.Localization.tableName) -> String {
        NSLocalizedString(self, tableName: table, comment: "")
    }

    func localized(
        _ args: CVarArg...,
        table: String = AppConstants.Localization.tableName
    ) -> String {
        String(format: localized(table: table), arguments: args)
    }
}
