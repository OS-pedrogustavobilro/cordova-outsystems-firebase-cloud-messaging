/// Delegate for the event trigger. Should be called by the plugin.
public protocol FirebaseMessagingEventProtocol: AnyObject {
    /// Triggers an event with the data passed
    /// - Parameters:
    ///   - event: Event to be triggered
    ///   - data: Data to be processed
    func event(_ event: FirebaseEventType, data: String)
}
