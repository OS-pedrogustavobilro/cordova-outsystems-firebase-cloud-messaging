import Foundation

extension Date {
    /// Convert `timeIntervalSince1970` from seconds to milliseconds
    var millisecondsSince1970: Double {
        return (self.timeIntervalSince1970 * 1000.0).rounded()
    }
}
