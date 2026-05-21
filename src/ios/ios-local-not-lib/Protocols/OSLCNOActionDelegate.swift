public typealias OSLCNOSound = String

public protocol OSLCNOActionDelegate: AnyObject {
    func triggerNotification(with title: String, _ body: String?, _ badge: Int?, sound: OSLCNOSound?, actions: [OSLCNOAction]?, and internalEvent: OSLCNOInternalEvent?) async throws
    func clearNotificationCategory(with id: String) async
}
