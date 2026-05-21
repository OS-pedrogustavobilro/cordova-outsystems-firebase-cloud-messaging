/// Enum object containing all type of events that can be triggered
public enum FirebaseEventType {
    case trigger(notification: FirebaseNotificationType)
    case click(type: OSFCMClickableType)
}

/// Enum object containing all type of notifications.
public enum FirebaseNotificationType {
    case defaultNotification
    case silentNotification
}

public enum OSFCMClickableType {
    case notification(latestVersion: Bool)
    case action
}
