protocol OSLCNOContentDelegate: AnyObject {
    associatedtype Notification = Self
    static func createNotification(with title: String, _ body: String, badge: Int?, and sound: OSLCNOSound?) -> Notification
}

extension OSLCNOContentDelegate {
    static func createNotification(with title: String, _ body: String, and sound: OSLCNOSound?) -> Notification {
        self.createNotification(with: title, body, badge: nil, and: sound)
    }
}
