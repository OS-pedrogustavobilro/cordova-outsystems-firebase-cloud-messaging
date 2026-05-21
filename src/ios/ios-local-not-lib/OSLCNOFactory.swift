import UserNotifications

public struct OSLCNOFactory {
    public static func createUNWrapper() -> OSLCNOActionDelegate {
        OSLCNOWrapper<UNUserNotificationCenter, UNMutableNotificationContent>(center: .current())
    }
}
