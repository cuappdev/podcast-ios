//
//  ItemSource+CoreDataProperties.swift
//  
//
//  Created by Mindy Lou on 11/1/18.
//
//

import Foundation
import CoreData


extension ItemSource {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemSource> {
        return NSFetchRequest<ItemSource>(entityName: "ItemSource")
    }

    @NSManaged public var url: String?
    @NSManaged public var value: String?
    @NSManaged public var episode: Episode?

}
