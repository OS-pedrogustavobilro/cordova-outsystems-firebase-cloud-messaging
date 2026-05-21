import Foundation

/// All plugin errors that can be thrown
public enum OSLCNOError: Int, CustomNSError, LocalizedError {
    case noTitle = 1
    case triggerError = 2
    
    /// Textual description
    public var errorDescription: String? {
        switch self {
        case .noTitle:
            return "A notification must have a title set."
        case .triggerError:
            return "There was an error while triggering the notification."
        }
    }
}
