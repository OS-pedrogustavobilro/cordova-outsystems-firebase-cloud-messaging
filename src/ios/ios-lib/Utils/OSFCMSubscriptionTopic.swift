public enum OSFCMSubscriptionTopic {
    case general
    case appGeneral
    case specific(name: String)
    
    func getTopicName(generalTopic: String, appGeneralTopic: String) -> String {
        return if case .specific(let name) = self {
            name
        } else if case .appGeneral = self {
            appGeneralTopic
        } else {
            generalTopic
        }
    }
}
