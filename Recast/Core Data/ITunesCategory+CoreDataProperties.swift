//
//  ITunesCategory+CoreDataProperties.swift
//  
//
//  Created by Mindy Lou on 11/3/18.
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

    enum Keys: String {
        case subcategory, value
    }

    func setValue(_ value: Any?, for key: Keys) {
        self.setValue(value, forKey: key.rawValue)
    }
}
