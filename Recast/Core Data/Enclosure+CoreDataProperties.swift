//
//  Enclosure+CoreDataProperties.swift
//  
//
//  Created by Mindy Lou on 11/3/18.
//
//

import Foundation
import CoreData


extension Enclosure {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Enclosure> {
        return NSFetchRequest<Enclosure>(entityName: "Enclosure")
    }

    @NSManaged public var length: Int64
    @NSManaged public var type: Int64
    @NSManaged public var url: URL?
    @NSManaged public var episode: Episode?

    enum Keys: String {
        case length, type, url
        case episode
    }

    func setValue(_ value: Any?, for key: Keys) {
        self.setValue(value, forKey: key.rawValue)
    }

}
