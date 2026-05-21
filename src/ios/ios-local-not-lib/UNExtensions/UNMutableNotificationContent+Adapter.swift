import UserNotifications

extension UNMutableNotificationContent: OSLCNOContentDelegate {
    static func createNotification(with title: String, _ body: String, badge: Int?, and sound: OSLCNOSound?) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        if let badge = badge, badge >= 0 {
            content.badge = NSNumber(value: badge)
        }
        if let sound = sound {
            let soundName = UNNotificationSoundName(sound)
            content.sound = UNNotificationSound(named: soundName)
        } else {
            content.sound = .default
        }
        
        return content
    }
}
