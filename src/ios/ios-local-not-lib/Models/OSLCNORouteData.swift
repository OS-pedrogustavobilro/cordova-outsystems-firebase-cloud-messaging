import Foundation

public struct OSLCNORouteData {
    let deepLinkScheme: String
    let identifier: String?
    let parameterData: [String: String]?
    let fallbackUrl: String?
    
    public init(deepLinkScheme: String, identifier: String? = nil, parameterData: [String: String]? = nil, fallbackUrl: String? = nil) {
        self.deepLinkScheme = deepLinkScheme
        self.identifier = identifier
        self.parameterData = parameterData
        self.fallbackUrl = fallbackUrl
    }
}

extension OSLCNORouteData: Codable {
    enum CodingKeys: CodingKey {
        case deepLinkScheme
        case identifier
        case parameterData
        case fallbackUrl
    }
    
    enum FallbackURLCodingKeys: CodingKey {
        case iOS
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let deepLinkScheme = try container.decode(String.self, forKey: .deepLinkScheme)
        let identifier = try container.decodeIfPresent(String.self, forKey: .identifier)
        let parameterData = try container.decodeIfPresent([String: String].self, forKey: .parameterData)
        
        var fallbackUrl: String?
        if container.contains(.fallbackUrl) {
            let fallbackURLContainer = try container.nestedContainer(keyedBy: FallbackURLCodingKeys.self, forKey: .fallbackUrl)
            fallbackUrl = try fallbackURLContainer.decodeIfPresent(String.self, forKey: .iOS)
        }
        
        self.init(deepLinkScheme: deepLinkScheme, identifier: identifier, parameterData: parameterData, fallbackUrl: fallbackUrl)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(self.deepLinkScheme, forKey: .deepLinkScheme)
        try container.encodeIfPresent(self.identifier, forKey: .identifier)
        try container.encodeIfPresent(self.parameterData, forKey: .parameterData)
        
        var fallbackURLContainer = container.nestedContainer(keyedBy: FallbackURLCodingKeys.self, forKey: .fallbackUrl)
        try fallbackURLContainer.encodeIfPresent(self.fallbackUrl, forKey: .iOS)
    }
}
