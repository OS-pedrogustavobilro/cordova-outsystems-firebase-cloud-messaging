extension OSLCNOActionDelegate {
    func triggerNotification(with title: String, _ body: String?, and badge: Int?) async throws {
        try await self.triggerNotification(with: title, body, badge, sound: nil, actions: nil, and: nil)
    }
    
    func triggerNotification(with title: String, _ body: String, _ sound: OSLCNOSound?, _ actions: [OSLCNOAction]?, and internalEvent: OSLCNOInternalEvent?) async throws {
        try await self.triggerNotification(with: title, body, nil, sound: sound, actions: actions, and: internalEvent)
    }
    
    func trigger(pushNotification notification: OSFCMPushNotificationModel, with internalEvent: OSLCNOInternalEvent?) async throws {
        try await self.triggerNotification(with: notification.title, notification.body, notification.sound, notification.actionArray, and: internalEvent)
    }
}
