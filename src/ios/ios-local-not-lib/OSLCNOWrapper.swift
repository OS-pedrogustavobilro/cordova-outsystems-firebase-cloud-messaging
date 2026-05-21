import Foundation

final class OSLCNOWrapper<
    Center: OSLCNOCenterDelegate, Content: OSLCNOContentDelegate
>: NSObject where Center.Notification == Content.Notification {
    private let center: Center
    
    init(center: Center) {
        self.center = center
    }
}

extension OSLCNOWrapper: OSLCNOActionDelegate {
    typealias Notification = Content.Notification
    
    func triggerNotification(with title: String, _ body: String?, _ badge: Int?, sound: OSLCNOSound?, actions: [OSLCNOAction]?, and internalEvent: OSLCNOInternalEvent?) async throws {
        guard !title.isEmpty else { throw OSLCNOError.noTitle }
        
        let body = body ?? ""
        
        let notification: Notification
        if let badge = badge, badge >= 0 {
            notification = Content.createNotification(with: title, body, badge: badge, and: sound)
        } else {
            notification = Content.createNotification(with: title, body, and: sound)
        }
       
        do {
            try await self.center.trigger(notification, with: actions, and: internalEvent)
        } catch {
            throw OSLCNOError.triggerError
        }
    }
    
    func clearNotificationCategory(with id: String) async {
        await self.center.clearNotificationCategory(with: id)
    }
    
}
