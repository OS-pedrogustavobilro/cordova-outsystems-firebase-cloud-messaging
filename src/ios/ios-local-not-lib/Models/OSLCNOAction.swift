import Foundation

/// A notification action
public struct OSLCNOAction: Codable {
    let identifier: String
    let label: String
    let textField: OSLCNOActionTextField?
    let type: OSLCNOActionType
    let event: OSLCNOActionEvent
    let routeData: OSLCNORouteData
    
    public init(identifier: String, label: String, textField: OSLCNOActionTextField? = nil, type: OSLCNOActionType, event: OSLCNOActionEvent, routeData: OSLCNORouteData) {
        self.identifier = identifier
        self.label = label
        self.textField = textField
        self.type = type
        self.event = event
        self.routeData = routeData
    }
}

extension OSLCNOAction {
    enum OSLCNOActionError: Error {
        case unexpectedEvent
        case identifierMissing
        case fallbackURLMissing
    }
    
    private func mergeParameterData(with userText: String?) -> [String: String]? {
        var result = self.routeData.parameterData
        
        if let newValue = userText, let newKey = self.textField?.inputTextKey {
            if result != nil {
                result?[newKey] = newValue
            } else {
                result = [newKey: newValue]
            }
        }
        
        return result
    }
}

// MARK: - Internal Route Event
public extension OSLCNOAction {
    func getParameterData(withUserText userText: String?) throws -> [String: String]? {
        guard self.event == .internalRoute else { throw OSLCNOActionError.unexpectedEvent }
        return self.mergeParameterData(with: userText)
    }
    
    var internalScreenName: String {
        get throws {
            guard self.event == .internalRoute else { throw OSLCNOActionError.unexpectedEvent }
            return self.routeData.deepLinkScheme
        }
    }
}

// MARK: - External Route Event (Web & App)
public extension OSLCNOAction {
    private var identifierSeparator: Character { "/" }
    
    func getRouteURL(withUserText userText: String?) throws -> URL? {
        switch self.event {
        case .webRoute:
            return try self.getWebURL(with: userText)
        case .appRoute:
            return self.getAppURL(with: userText)
        default:
            throw OSLCNOActionError.unexpectedEvent
        }
    }
    
    var fallbackURL: URL? {
        get throws {
            guard self.event == .appRoute else { throw OSLCNOActionError.unexpectedEvent }
            guard let urlString = self.routeData.fallbackUrl else { throw OSLCNOActionError.fallbackURLMissing }
            
            return URL(string: urlString)
        }
    }
    
    private func getWebURL(with userText: String?) throws -> URL? {
        guard let identifier = self.routeData.identifier else { throw OSLCNOActionError.identifierMissing }
        
        var urlComponents = URLComponents()
        urlComponents.scheme = self.routeData.deepLinkScheme
        
        let hostPath = identifier.split(separator: self.identifierSeparator, maxSplits: 1).map(String.init)
        urlComponents.host = hostPath.first
        if hostPath.count > 1, let path = hostPath.last {
            urlComponents.path = "/\(path)"
        }
        
        if let parameters = self.mergeParameterData(with: userText), !parameters.isEmpty {
            urlComponents.queryItems = parameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        return urlComponents.url
    }
    
    private func getAppURL(with userText: String?) -> URL? {
        var urlString = "\(self.routeData.deepLinkScheme)://"
        
        if let identifier = self.routeData.identifier {
            urlString += identifier
        }
        
        if let parameters = self.mergeParameterData(with: userText), !parameters.isEmpty {
            parameters.enumerated().forEach { item in
                if item.offset == 0 {
                    urlString += "?"
                }
                
                if let value = item.element.value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                    urlString += "\(item.element.key)=\(value)"
                    
                    if item.offset != parameters.count - 1 {
                        urlString += "&"
                    }
                }
            }
        }
        
        return URL(string: urlString)
    }
}
