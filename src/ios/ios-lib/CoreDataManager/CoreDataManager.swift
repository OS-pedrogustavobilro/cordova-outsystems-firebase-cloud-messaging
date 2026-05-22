import CoreData

/// Object that manages all accesses to the Core Data layer
@objc open class CoreDataManager: NSObject {
    /// Core Data name.
    public static let modelName = "NotificationsModel"
    /// Programmatic representation of the `xcdatamodeld` file that describe all objects.
    public static let model: NSManagedObjectModel = {
        let customBundle = Bundle(for: CoreDataManager.self)
        guard let modelURL = customBundle.url(forResource: CoreDataManager.modelName, withExtension: "momd") else {
            fatalError("Error initializing mom")
        }
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    /// Container that encapsulates the Core Data stack in the app.
    public lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: CoreDataManager.modelName, managedObjectModel: CoreDataManager.model)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    /// Method to return the main queue's managed object context.
    /// - Returns: Managed object context of the container.
    public func context() -> NSManagedObjectContext {
        return self.storeContainer.viewContext
    }
    
    /// Returns an array of items of the specified type that meet the fetch request’s criteria.
    /// - Parameter request: Search criteria to filter the retrieved data.
    /// - Returns: The result of the data search considering the criteria used.
    public func fetch<T>(_ request: NSFetchRequest<T>) throws -> [T] where T: NSFetchRequestResult {
        return try self.storeContainer.viewContext.fetch(request)
    }
    
    public func saveContext () throws {
        let context = self.storeContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                context.rollback()
                throw error
            }
        }
    }
    
}
