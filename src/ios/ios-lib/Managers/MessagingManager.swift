import FirebaseCore
import FirebaseMessaging

/// Class that manages and triggers all methods required to reliable deliver all messages.
public class MessagingManager: MessagingProtocol {
    /// Empy construct method. It's required to publicly expose the class.
    public init() {
        // needed init to expose the class
    }
    
    /// Returns the token associated to the parameter `type`.
    /// If `fcm` it returns the Firebase Cloud Messaging registration token.
    /// If `apns` it returns  the Apple Push Notification service token.
    ///  This token is obtained asynchronously.
    /// - Returns: Registration token.
    /// - Parameter type: type of token to return. Can be `FCM` or `APNs`.
    public func getToken(of type: OSFCMTokenType) async throws -> String {
        var result: String
        let messagingInstance = Messaging.messaging()
        
        if type == .apns {
            guard let data = messagingInstance.apnsToken else { throw FirebaseMessagingErrors.obtainingTokenError }
            result = data.map { String(format: "%02.2hhx", $0) }.joined()
        } else {
            result = try await messagingInstance.token()
        }
        
        return result
    }
    
    /// Deletes the Firebase cloud Messaging registration token. The deletion is made asynchronously.
    public func deleteToken() async throws {
        try await Messaging.messaging().deleteToken()
    }
    
    /// Subscribes to a provided topic. The subscription is done asynchronously.
    /// - Parameter topic: Topic to subscribe to.
    public func subscribe(toTopic topic: String) async throws {
        try await Messaging.messaging().subscribe(toTopic: topic)
    }
    
    /// Unsubscribes from the provided topic. The subscription is done asynchronously.
    /// - Parameter topic: Topic to unsubscribe from.
    public func unsubscribe(fromTopic topic: String) async throws {
        try await Messaging.messaging().unsubscribe(fromTopic: topic)
    }

}
