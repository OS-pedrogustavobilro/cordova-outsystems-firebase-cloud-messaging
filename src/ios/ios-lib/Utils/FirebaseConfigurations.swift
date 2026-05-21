import Foundation

/// Responsible for configuring the necessary files to enable Firebase Cloud Messaging in the app.
public class FirebaseConfiguration {
    /// Name of the file containing the configuration
    private let fileName: String
    
    /// Bundle containing the configuration file
    private let bundle: Bundle
    
    /// Constructor method.
    /// - Parameters:
    ///   - fileName: Name of the file containing the configuration. A default value for Google Services is provided
    ///   - bundle: Bundle containing the configuration file. A default `main` value is provided.
    public init(fileName: String = "GoogleService-Info", bundle: Bundle = Bundle.main) {
        self.fileName = fileName
        self.bundle = bundle
    }
    
    /// Returns the full path for the configuration file
    /// - Returns: Full path for the configuration file, if it exists.
    public func getGoogleServicesPath() -> String? {
        return self.bundle.path(forResource: self.fileName, ofType: "plist")
    }
}
