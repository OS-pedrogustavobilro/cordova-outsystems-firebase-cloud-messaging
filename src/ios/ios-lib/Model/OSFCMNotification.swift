import CoreData

/// Core Data Model that stores the properties associated with a Notification.
@objc(OSFCMNotification)
public class OSFCMNotification: NSManagedObject, Codable {
    
    /// Constructor method inherited from `NSManagedObject`.
    /// - Parameters:
    ///   - entity: A description of an entity in Core Data.
    ///   - context: An object space to manipulate and track changes to managed objects.
    private override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    /// Constructor method.
    /// - Parameters:
    ///   - messageID: Message identifier.
    ///   - extraDataList: List of dynamic properties.
    ///   - timeToLive: Text representation of the expiration datetime.
    ///   - timeStamp: Numeric representation of the creation datetime,
    ///   - context: An object space to manipulate and track changes to managed objects.
    init(messageID: String,
         extraDataList: [OSFCMExtraData],
         timeToLive: String,
         timeStamp: Double,
         context: NSManagedObjectContext) {
        super.init(entity: NSEntityDescription.entity(forEntityName: "OSFCMNotification", in: context)!, insertInto: context)
        self.messageID = messageID
        self.extraDataList = NSSet(array: extraDataList)
        self.timeToLive = timeToLive
        self.timeStamp = timeStamp
    }
    
    /// An enumeration used as a key for encoding and decoding.
    enum CodingKeys: String, CodingKey {
        case messageID, extraDataList, timeToLive, timeStamp
    }
    
    /// Method used to transform the object properties into an external representation format.
    /// - Parameter encoder:  Object used to encode values into a native format for external representation.
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(messageID, forKey: .messageID)
        try container.encode(extraDataList?.allObjects as? [OSFCMExtraData], forKey: .extraDataList)
        try container.encode(timeToLive, forKey: .timeToLive)
        try container.encode(timeStamp, forKey: .timeStamp)
    }
    
    /// Constructor method used to translate the object properties into a in-memory representation format.
    /// - Parameter decoder:  Object used to decode values from a native format into in-memory representations.
    public required convenience init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            fatalError()
        }
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let messageID = try container.decode(String.self, forKey: .messageID)
        let extraDataList = try container.decode([OSFCMExtraData].self, forKey: .extraDataList)
        let timeToLive = try container.decode(String.self, forKey: .timeToLive)
        let timeStamp = try container.decode(Double.self, forKey: .timeStamp)
        self.init(messageID: messageID, extraDataList: extraDataList, timeToLive: timeToLive, timeStamp: timeStamp, context: context)
    }
    
}

extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}
