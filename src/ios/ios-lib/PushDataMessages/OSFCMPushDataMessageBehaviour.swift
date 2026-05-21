import Foundation

final class OSFCMPushDataMessageBehaviour: OSFCMPushDataMessage {
    var localNotificationsWrapper: OSLCNOActionDelegate
    
    init(localNotificationsWrapper: OSLCNOActionDelegate) {
        self.localNotificationsWrapper = localNotificationsWrapper
    }
    
    func createPushNotification(from model: OSFCMDataMessageModel, _ deepLink: String?, and extraDataList: [[String: Any]]?) {
        if let modelData = model.data(using: .utf8),
           let notification = try? JSONDecoder().decode(OSFCMPushNotificationModel.self, from: modelData) {
            var parameterArray: [OSLCNOParameter]?
            if let extraDataList, let parameterArrayData = try? JSONSerialization.data(withJSONObject: extraDataList) {
                parameterArray = try? JSONDecoder().decode([OSLCNOParameter].self, from: parameterArrayData)
            }

            let internalEvent = OSLCNOInternalEvent(screenName: deepLink ?? "", parameterArray: parameterArray)
            Task {
                try await self.localNotificationsWrapper.trigger(pushNotification: notification, with: internalEvent)
            }
        }
    }
    
    func clearNotificationCategory(with id: String) {
        Task {
            await self.localNotificationsWrapper.clearNotificationCategory(with: id)
        }
    }
}
