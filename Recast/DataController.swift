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
    var managedObjectContext: NSManagedObjectContext
    var persistentContainer: NSPersistentContainer

    init(completion: @escaping () -> Void) {
        persistentContainer = NSPersistentContainer(name: "DataModel")
        managedObjectContext = persistentContainer.viewContext
        persistentContainer.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
            completion()
        }
    }
}
