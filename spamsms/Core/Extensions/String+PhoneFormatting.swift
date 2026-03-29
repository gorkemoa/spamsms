import Foundation

extension String {

    /// Strips all non-digit characters except a leading '+'.
    var strippedPhoneFormatting: String {
        var result = ""
        for (index, char) in self.enumerated() {
            if char == "+" && index == 0 {
                result.append(char)
            } else if char.isNumber {
                result.append(char)
            }
        }
        return result
    }

    /// Loose format check after stripping formatting characters.
    var looksLikePhoneNumber: Bool {
        let stripped = strippedPhoneFormatting
        let digitCount = stripped.filter(\.isNumber).count
        return digitCount >= 7 && digitCount <= 15
    }
}
