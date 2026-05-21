import CoreData
import OSLocalNotificationsLib
import UserNotifications

/// Manages and controls sending notifications.
public protocol NotificationManagerProtocol {
    
    /// Inserts a notification on to Core Data. The input notifications comes in form of a Dictionary, so it needs to be transformed into the corresponding Core Data models.
    /// - Parameter notificationDict: Notification data.
    /// - Returns: A boolean indicating the success of the operation or an error, in case of failure.
    func insertNotification(notificationDict: [String: Any]) -> Result<Bool, Error>
    
    /// Fetches the store notifications on Core Data.
    /// - Returns: An array of notifications or an error, in case of failure.
    func fetchNotifications() -> Result<[OSFCMNotification], Error>
    
    /// Sends a local notification on to the Notification Center.
    /// - Parameters:
    ///   - title: Main title.
    ///   - body: Description.
    ///   - badge: Badge to display.
    /// - Returns: A boolean indicating the success of the operation or an error, in case of failure.
    func sendLocalNotification(title: String, body: String, badge: Int) async -> Result<Bool, Error>
}

/// Manages notification sending and storage on Core Data
public final class NotificationManager: NSObject {
    
    /// Protocol that manages notification-related activities.
    private let notificationCenter: UNUserNotificationCenterProtocol
    /// Object that manages notification Core Data related activites.
    private let coreDataManager: CoreDataManager
    
    private let localNotificationWrapper: OSLCNOActionDelegate
    
    /// Constructor method.
    /// - Parameters:
    ///   - coreDataManager: Manages Core Data related activites.
    ///   - notificationCenter: Manages Notification related activities.
    init(coreDataManager: CoreDataManager, notificationCenter: UNUserNotificationCenterProtocol, localNotificationWrapper: OSLCNOActionDelegate) {
        self.coreDataManager = coreDataManager
        self.notificationCenter = notificationCenter
        self.localNotificationWrapper = localNotificationWrapper
        super.init()
    }
    
    /// Convenience constructor method.
    /// - Parameter coreDataManager: Manages CoreData related activities. Default value provided.
    public convenience init(coreDataManager: CoreDataManager = CoreDataManager()) {
        let notificationCenter = UNUserNotificationCenter.current()
        let localNotificationWrapper = OSLCNOFactory.createUNWrapper()
        self.init(
            coreDataManager: coreDataManager, notificationCenter: notificationCenter, localNotificationWrapper: localNotificationWrapper
        )
    }
    
    /// Requests user authorization for the app to notify the user via both local and remote notificataions through the notification center.
    /// - Parameter options: Possibilities for requesting authorization to interact with the user.
    /// - Returns: A boolean indicating the success of the operation
    func requestAuthorization(options: UNAuthorizationOptions) async throws -> Bool {
        do {
            return try await self.notificationCenter.requestAuthorization(options: options)
        } catch {
            throw FirebaseMessagingErrors.requestPermissionsError
        }
    }
    
    /// Removes all delivered notifications to the notification center.
    func removeAllDeliveredNotifications() {
        self.notificationCenter.removeAllDeliveredNotifications()
    }
    
    /// Deletes all notifications provided by input from Core Data manager.
    /// - Parameter notifications: Notifications to remove.
    /// - Returns: A boolean indicating the success of the operation or an error, in case of failure.
    public func deletePendingNotifications(_ notifications: [OSFCMNotification]) -> Result<Bool, Error> {
        let fetchRequest: NSFetchRequest<OSFCMNotification> = OSFCMNotification.fetchRequest()
        do {
            let fetchRequestResults = try self.coreDataManager.fetch(fetchRequest)
            let filtered = fetchRequestResults.filter({ notifications.contains($0) })
            if !filtered.isEmpty {
                for item in filtered {
                    self.coreDataManager.context().delete(item)
                }
            }
            try self.coreDataManager.saveContext()
        } catch {
            return .failure(error)
        }
        return .success(true)
    }
    
}

extension NotificationManager: NotificationManagerProtocol {
    
    /// Sends a local notification on to the notification center.
    /// - Parameters:
    ///   - title: Main title.
    ///   - body: Description.
    ///   - badge: Badge to display.
    /// - Returns: A boolean indicating the success of the operation or an error, in case of failure.
    public func sendLocalNotification(title: String, body: String, badge: Int) async -> Result<Bool, Error> {
        do {
            try await self.localNotificationWrapper.triggerNotification(with: title, body, and: badge)
            return .success(true)
        } catch {
            return .failure(error)
        }
    }
    
    /// Inserts a notification on to Core Data. The input notifications comes in form of a Dictionary, so it needs to be transformed into the corresponding Core Data models.
    /// - Parameter notificationDict: Notification data.
    /// - Returns: A boolean indicating the success of the operation or an error, in case of failure.
    public func insertNotification(notificationDict: [String: Any]) -> Result<Bool, Error> {
        let decoder = JSONDecoder()
        decoder.userInfo[CodingUserInfoKey.managedObjectContext] = self.coreDataManager.context()
        do {
            let notificationData = try JSONSerialization.data(withJSONObject: notificationDict)
            _ = try decoder.decode(OSFCMNotification.self, from: notificationData)
            
            try self.coreDataManager.saveContext()
        } catch {
            return .failure(error)
        }
        
        return .success(true)
    }
    
    /// Fetches the store notifications on Core Data.
    /// - Returns: An array of notifications or an error, in case of failure.
    public func fetchNotifications() -> Result<[OSFCMNotification], Error> {
        let fetchRequest: NSFetchRequest<OSFCMNotification> = OSFCMNotification.fetchRequest()
        do {
            let notifications = try self.coreDataManager.fetch(fetchRequest)
            return .success(notifications)            
        } catch {
            return .failure(error)
        }
        
    }
    
}
