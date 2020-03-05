//
//  CoreDataManager.swift
//  TS Time Tracking
//
//  Created by Thomas Sillmann on 28.01.20.
//  Copyright © 2020 Thomas Sillmann. All rights reserved.
//

import CoreData

class CoreDataManager {
    
    // MARK: - Properties
    
    static let shared = CoreDataManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TS_Time_Tracking")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in })
        return container
    }()
    
    var managedObjectContext: NSManagedObjectContext {
        let managedObjectContext = persistentContainer.viewContext
        managedObjectContext.automaticallyMergesChangesFromParent = true
        return managedObjectContext
    }
    
    // MARK: - Methods
    
    func managedObjectExists(withID objectID: NSManagedObjectID) -> Bool {
        if (try? managedObjectContext.existingObject(with: objectID)) != nil {
            return true
        }
        return false
    }
    
    func saveContext () {
        let managedObjectContext = self.managedObjectContext
        if managedObjectContext.hasChanges {
            try? managedObjectContext.save()
        }
    }
    
    func deleteAllContent() {
        TimeTrackingManager.shared.deleteAllTimeTrackings()
        TimeTrackingGroupManager.shared.deleteAllTimeTrackingGroups()
    }
    
}
