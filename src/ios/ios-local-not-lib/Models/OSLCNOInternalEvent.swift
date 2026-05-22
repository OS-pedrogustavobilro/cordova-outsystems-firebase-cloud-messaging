public struct OSLCNOInternalEvent: Codable {
    let screenName: String
    let parameterArray: [OSLCNOParameter]?

    public enum CodingKeys: String, CodingKey, CaseIterable {
        case screenName, parameterArray
    }

    public init(screenName: String, parameterArray: [OSLCNOParameter]?) {
        self.screenName = screenName
        self.parameterArray = parameterArray
    }
}
