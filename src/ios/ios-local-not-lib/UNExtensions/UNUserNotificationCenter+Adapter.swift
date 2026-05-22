import UserNotifications

extension UNUserNotificationCenter: OSLCNOCenterDelegate {
    func trigger(_ notification: UNMutableNotificationContent, with actions: [OSLCNOAction]?, and internalEvent: OSLCNOInternalEvent?) async throws {
        let uuidString = UUID().uuidString
        
        if let actions = actions, !actions.isEmpty {
            var notificationActions: [UNNotificationAction] = []
            for action in actions {
                var notificationAction: UNNotificationAction
                if action.textField != nil {
                    notificationAction = UNTextInputNotificationAction(textInputFrom: action)
                } else {
                    notificationAction = UNNotificationAction(from: action)
                }
                notificationActions.append(notificationAction)
                
                notification.userInfo[action.identifier] = action.asDictionary
            }
            let category = UNNotificationCategory(identifier: uuidString, actions: notificationActions, intentIdentifiers: [])
            notification.categoryIdentifier = category.identifier
            
            var categories = await self.notificationCategories()
            categories.insert(category)
            self.setNotificationCategories(categories)
        }
        
        if let internalEvent = internalEvent {
            notification.userInfo[OSLCNOInternalEvent.CodingKeys.screenName.stringValue] = internalEvent.screenName
            if let parameterArray = internalEvent.parameterArray {
                notification.userInfo[OSLCNOInternalEvent.CodingKeys.parameterArray.stringValue] = parameterArray.asDictionary
            }
        }
        
        let request = UNNotificationRequest(identifier: uuidString, content: notification, trigger: nil)
        
        // Schedule the request with the system.
        try await self.add(request)
    }
    
    func clearNotificationCategory(with id: String) async {
        let categories = await self.notificationCategories().filter { $0.identifier != id }
        self.setNotificationCategories(categories)
    }
}
