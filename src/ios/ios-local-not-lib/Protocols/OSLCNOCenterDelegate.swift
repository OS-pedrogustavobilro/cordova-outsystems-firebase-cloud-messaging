import UserNotifications
protocol OSLCNOCenterDelegate: AnyObject {
    associatedtype Notification = OSLCNOContentDelegate
    
    func trigger(_ notification: Notification, with actions: [OSLCNOAction]?, and internalEvent: OSLCNOInternalEvent?) async throws
    func clearNotificationCategory(with id: String) async
}
