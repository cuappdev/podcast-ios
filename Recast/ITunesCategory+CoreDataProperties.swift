//
//  ITunesCategory+CoreDataProperties.swift
//  
//
//  Created by Mindy Lou on 11/1/18.
//
//

import Foundation
import CoreData


extension ITunesCategory {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ITunesCategory> {
        return NSFetchRequest<ITunesCategory>(entityName: "ITunesCategory")
    }

    @NSManaged public var subcategory: String?
    @NSManaged public var value: String?

}
