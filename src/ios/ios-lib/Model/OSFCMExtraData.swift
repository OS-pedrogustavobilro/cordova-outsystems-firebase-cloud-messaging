import CoreData

/// Core Data Model that stores the dynamic properties associated with a specific Notification.
@objc(OSFCMExtraData)
public class OSFCMExtraData: NSManagedObject, Codable {
    
    /// Constructor method inherited from `NSManagedObject`.
    /// - Parameters:
    ///   - entity: A description of an entity in Core Data.
    ///   - context: An object space to manipulate and track changes to managed objects.
    private override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    /// Constructor method.
    /// - Parameters:
    ///   - key: Property label.
    ///   - value: Property value.
    ///   - context: An object space to manipulate and track changes to managed objects.
    init(key: String,
         value: String,
         context: NSManagedObjectContext) {
        super.init(entity: NSEntityDescription.entity(forEntityName: "OSFCMExtraData", in: context)!, insertInto: context)
        self.key = key
        self.value = value
    }
    
    /// An enumeration used as a key for encoding and decoding.
    enum CodingKeys: String, CodingKey {
        case key, value
    }
    
    /// Method used to transform the object properties into an external representation format.
    /// - Parameter encoder:  Object used to encode values into a native format for external representation.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(key, forKey: .key)
        try container.encode(value, forKey: .value)
    }
    
    /// Constructor method used to translate the object properties into a in-memory representation format.
    /// - Parameter decoder:  Object used to decode values from a native format into in-memory representations.
    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            fatalError()
        }
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let key = try container.decode(String.self, forKey: .key)
        let value = try container.decode(String.self, forKey: .value)
        self.init(key: key, value: value, context: context)
    }
    
}
