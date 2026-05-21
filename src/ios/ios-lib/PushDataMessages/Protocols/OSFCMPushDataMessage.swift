protocol OSFCMPushDataMessage: AnyObject {
    typealias OSFCMDataMessageModel = String
    
    var localNotificationsWrapper: OSLCNOActionDelegate { get set }
    
    func createPushNotification(from model: OSFCMDataMessageModel, _ deepLink: String?, and extraDataList: [[String: Any]]?)
    func clearNotificationCategory(with id: String)
}
