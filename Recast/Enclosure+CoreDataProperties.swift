//
//  Enclosure+CoreDataProperties.swift
//  
//
//  Created by Mindy Lou on 11/1/18.
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

}
