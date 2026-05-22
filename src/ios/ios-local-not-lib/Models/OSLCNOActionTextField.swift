public struct OSLCNOActionTextField: Codable {
    let placeholder: String
    let inputTextKey: String
    
    public init(placeholder: String, inputTextKey: String) {
        self.placeholder = placeholder
        self.inputTextKey = inputTextKey
    }
}
