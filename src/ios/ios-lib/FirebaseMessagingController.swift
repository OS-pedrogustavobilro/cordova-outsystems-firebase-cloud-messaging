import UIKit
import UserNotifications
import FirebaseCore
import FirebaseMessaging

open class FirebaseMessagingController: NSObject {
    private let firebaseManager: MessagingProtocol
    private let configuration: FirebaseConfiguration
    private let application: UIApplicationProtocol
    
    private var coreDataManager: CoreDataManager
    private var notificationManager: NotificationManager
    
    private let generalTopic: String
    private let appGeneralTopic: String
    
    public var badgeNumber: Int {
        get {
            self.application.getBadge()
        }
        set {
            self.application.setBadge(badge: newValue)
        }
    }
    
    init(
        firebaseManager: MessagingProtocol,
        configuration: FirebaseConfiguration,
        application: UIApplicationProtocol,
        coreDataManager: CoreDataManager,
        notificationManager: NotificationManager,
        generalTopic: String
    ) {
        self.configuration = configuration
        self.firebaseManager = firebaseManager
        self.application = application
        self.coreDataManager = coreDataManager
        self.notificationManager = notificationManager
        self.generalTopic = "\(FirebaseApp.app()?.options.gcmSenderID ?? "")\(generalTopic)"
        self.appGeneralTopic = "\(Bundle.main.bundleIdentifier ?? "")\(generalTopic)"
        super.init()
    }
    
    public convenience init(
        firebaseManager: MessagingManager = MessagingManager(),
        coreDataManager: CoreDataManager = CoreDataManager(),
        generalTopic: String = "-general-topic-ios"
    ) {
        self.init(
            firebaseManager: firebaseManager,
            configuration: FirebaseConfiguration(),
            application: UIApplication.shared,
            coreDataManager: coreDataManager,
            notificationManager: NotificationManager(coreDataManager: coreDataManager),
            generalTopic: generalTopic
        )
    }
    
    public func configureApp() {
        guard FirebaseApp.app() == nil else { return }
        FirebaseApp.configure()
    }
    
    public func getPendingNotifications() throws -> [OSFCMNotification] {
        return if case .success(let notifications) = self.notificationManager.fetchNotifications() {
            notifications
        } else {
            throw FirebaseMessagingErrors.obtainSilentNotificationsError
        }
    }
    
    public func delete(pendingNotifications: [OSFCMNotification]) throws {
        if case .failure(let error) = self.notificationManager.deletePendingNotifications(pendingNotifications) {
            throw error
        }
    }
    
    // MARK: Token Public Methods
    public func getToken(ofType type: OSFCMTokenType = .fcm) async throws -> String {
        return try await self.firebaseManager.getToken(of: type)
    }
    
    public func deleteToken() async throws {
        try await self.firebaseManager.deleteToken()
    }
    
    // MARK: Subscription Public Methods
    public func subscribe(toTopic topic: OSFCMSubscriptionTopic) async throws {
        try await self.perform(operation: firebaseManager.subscribe(toTopic:), for: topic)
    }
    
    public func unsubscribe(fromTopic topic: OSFCMSubscriptionTopic) async throws {
        try await self.perform(operation: firebaseManager.unsubscribe(fromTopic:), for: topic)
    }
    
    public func clearNotifications() {
        self.notificationManager.removeAllDeliveredNotifications()
    }
    
    public func sendLocalNotification(title: String, body: String, badge: Int) async throws {
        let result = await notificationManager.sendLocalNotification(title: title, body: body, badge: badge)
        if case .failure(let error) = result {
            throw error
        }
    }
    
    public func requestAuthorisation() async throws -> Bool {
        try await self.notificationManager.requestAuthorization(options: [.alert, .badge, .sound])
    }
}

private extension FirebaseMessagingController {
    func perform(operation: (String) async throws -> Void, for topic: OSFCMSubscriptionTopic) async throws {
        let topicName = topic.getTopicName(generalTopic: generalTopic, appGeneralTopic: appGeneralTopic)
        try await operation(topicName)
    }
}
