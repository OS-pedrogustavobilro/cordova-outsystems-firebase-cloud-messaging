import Foundation
import UserNotifications

extension UNNotificationActionOptions {
    init(from actionType: OSLCNOActionType, and actionEvent: OSLCNOActionEvent) {
        self.init()
        self.insert(.foreground)
        if actionType == .destructive {
            self.insert(.destructive)
        }
    }

}

extension UNNotificationAction {
    convenience init(from action: OSLCNOAction) {
        let identifier = action.identifier
        let title = action.label
        let options = UNNotificationActionOptions(from: action.type, and: action.event)
   
        self.init(identifier: identifier, title: title, options: options)
        
    }
}

extension UNTextInputNotificationAction {
    static let defaultButtonTitle = "Send"
    static let defaultPlaceholder = ""
    
    convenience init(textInputFrom action: OSLCNOAction) {
        let identifier = action.identifier
        let title = action.label
        let textInputButtonTitle = Self.defaultButtonTitle
        var textInputPlaceholder = Self.defaultPlaceholder
        
        if let textField = action.textField {
            textInputPlaceholder = textField.placeholder
        }
        
        let options = UNNotificationActionOptions(from: action.type, and: action.event)
        
        self.init(
            identifier: identifier,
            title: title,
            options: options,
            textInputButtonTitle: textInputButtonTitle,
            textInputPlaceholder: textInputPlaceholder)
        
    }
}
