//
//  CoreDataUnitTestHelper.swift
//  ToDo
//
//  Created by Lena on 8/5/17.
//  Copyright © 2017 Lena. All rights reserved.
//

import UIKit
import CoreData
class CoreDataUnitTestHelper: NSObject {
    
    public class func setupInMemoryPersistenceCoordinator() -> NSPersistentStoreCoordinator {

        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!

        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        } catch {
            print("Adding in-memory persistent store failed")
        }
        return persistentStoreCoordinator
    }
    public class func setUpInMemoryManagedObjectContext() -> NSManagedObjectContext {
        
        let persistentStoreCoordinator = self.setupInMemoryPersistenceCoordinator()
        let managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        
        
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        return managedObjectContext
    }
}
