import Foundation

extension Encodable {
    
    /// Transforms an encodable object into plain text.
    /// - Returns: The object transformed into text. Returns empty string in case of error
    public func encode() -> String {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(self)
            return String(data: data, encoding: .utf8)!
        } catch {
            return ""
        }
    }
}
