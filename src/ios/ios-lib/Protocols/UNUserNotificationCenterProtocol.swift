import UIKit

/// Protocol that manages notification related activities
protocol UNUserNotificationCenterProtocol {
    /// Requests user authorization for the app to notify the user via both local and remote notificataions through the notification center.
    /// - Parameter options: Possibilities for requesting authorization to interact with the user.
    /// - Returns: A boolean indicating the success of the operation
    func requestAuthorization(options: UNAuthorizationOptions) async throws -> Bool
    
    /// Removes all delivered notifications to the notification center.
    func removeAllDeliveredNotifications()
    
    /// Schedules the delivery of a local notification.
    /// - Parameter request: Object containing the notification payload and trigger information.
    func add(_ request: UNNotificationRequest) async throws
}

extension UNUserNotificationCenter: UNUserNotificationCenterProtocol {}

/// Protocol that provides applicable getters and setters UIApplication's badge and state
public protocol UIApplicationProtocol {
    /// Gets the badge number
    /// - Returns: Badge number
    func getBadge() -> Int
    
    /// Sets the badge number
    /// - Parameter badge: Badge number
    func setBadge(badge: Int)
    
    /// Gets the current application state
    /// - Returns: Application State
    func getApplicationState() -> UIApplication.State
    
    func canRouteTo(_ url: URL) -> Bool
    
    func routeTo(_ url: URL)
}

extension UIApplication: UIApplicationProtocol {
    /// Gets the badge number
    /// - Returns: Badge number
    public func getBadge() -> Int { self.applicationIconBadgeNumber }
    
    /// Sets the badge number
    /// - Parameter badge: Badge number
    public func setBadge(badge: Int) { self.applicationIconBadgeNumber = badge }
    
    /// Gets the current application state
    /// - Returns: Application State
    public func getApplicationState() -> State { self.applicationState }
    
    public func canRouteTo(_ url: URL) -> Bool { self.canOpenURL(url) }
    
    public func routeTo(_ url: URL) { self.open(url) }
}
