//
//  DataController.swift
//  Recast
//
//  Created by Mindy Lou on 9/19/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import Foundation
import CoreData

class DataController: NSObject {

    // MARK: Data variables

    /// Main managed object context, associated with the main queue
    lazy var managedObjectContext: NSManagedObjectContext = {
        let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        moc.parent = privateManagedObjectContext
        return moc
    }()

    /// Private managed object context, accessible across queues
    lazy var privateManagedObjectContext: NSManagedObjectContext = {
        let privateMOC = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateMOC.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
        return privateMOC
    }()

    var persistentContainer: NSPersistentContainer

    init(completion: @escaping () -> Void) {
        persistentContainer = NSPersistentContainer(name: "DataModel")
        persistentContainer.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
            completion()
        }
        // Uncomment to print out which file directory the sqlite store is in
        print(persistentContainer.persistentStoreCoordinator.persistentStores.first?.url ?? "")
    }

    /// Saves data for everything in the child managed object context.
    /// Pushes changes from the main managed object context to the private moc
    /// Pushes changes from private moc to persistent store coordinator
    func saveData() {
        // Synchronously push changes to moc
        // This ensures the private moc has all changes
        managedObjectContext.performAndWait {
            do {
                if managedObjectContext.hasChanges {
                    try managedObjectContext.save()
                }
            } catch {
                let saveError = error as NSError
                print("\(saveError): \(saveError.localizedDescription)")
            }
        }

        privateManagedObjectContext.perform {
            do {
                if self.privateManagedObjectContext.hasChanges {
                    try self.privateManagedObjectContext.save()
                }
            } catch {
                let saveError = error as NSError
                print("\(saveError): \(saveError.localizedDescription)")
            }
        }
    }

}
