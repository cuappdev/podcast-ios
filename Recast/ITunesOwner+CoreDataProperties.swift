//
//  ITunesOwner+CoreDataProperties.swift
//  
//
//  Created by Mindy Lou on 11/1/18.
//
//

import Foundation
import CoreData


extension ITunesOwner {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ITunesOwner> {
        return NSFetchRequest<ITunesOwner>(entityName: "ITunesOwner")
    }

    @NSManaged public var email: String?
    @NSManaged public var name: String?
    @NSManaged public var namespace: ITunesNamespace?

}
