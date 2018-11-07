//
//  ITunesOwner+CoreDataProperties.swift
//  
//
//  Created by Mindy Lou on 11/3/18.
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

    enum Keys: String {
        case email, name
        case namespace
    }

    func setValue(_ value: Any?, for key: Keys) {
        self.setValue(value, forKey: key.rawValue)
    }
}
