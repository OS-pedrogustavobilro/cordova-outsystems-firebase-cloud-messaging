/// Delegate to manage and trigger all methods required to reliable deliver all messages.
public protocol MessagingProtocol {
    /// Returns the token associated to the parameter `type`.
    /// If `fcm` it returns the Firebase Cloud Messaging registration token.
    /// If `apns` it returns  the Apple Push Notification service token.
    ///  This token is obtained asynchronously.
    /// - Returns: Registration token.
    /// - Parameter type: type of token to return. Can be `FCM` or `APNs`.
    func getToken(of type: OSFCMTokenType) async throws -> String
    
    /// Deletes the Firebase cloud Messaging registration token. The deletion is made asynchronously.
    func deleteToken() async throws
    
    /// Subscribes to a provided topic. The subscription is done asynchronously.
    /// - Parameter topic: Topic to subscribe to.
    func subscribe(toTopic topic: String) async throws
    
    /// Unsubscribes from the provided topic. The subscription is done asynchronously.
    /// - Parameter topic: Topic to unsubscribe from.
    func unsubscribe(fromTopic topic: String) async throws
}
