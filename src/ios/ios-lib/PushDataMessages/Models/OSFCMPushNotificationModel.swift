import OSLocalNotificationsLib

struct OSFCMPushNotificationModel: Decodable {
    let title: String
    let body: String
    let sound: OSLCNOSound?
    let actionArray: [OSLCNOAction]?
}
