import Foundation

extension Encodable {
    var asDictionary: [String: Any] {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(self),
              let dictionary = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
        else { return [:] }
        return dictionary
    }
}

extension Array where Element: Encodable {
    var asDictionary: [[String: Any]] {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(self),
              let array = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]]
        else { return [] }
        return array
    }
}
