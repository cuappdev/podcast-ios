//
//  TextInput+CoreDataProperties.swift
//  
//
//  Created by Mindy Lou on 11/1/18.
//
//

import Foundation
import CoreData


extension TextInput {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TextInput> {
        return NSFetchRequest<TextInput>(entityName: "TextInput")
    }

    @NSManaged public var descriptionText: String?
    @NSManaged public var link: String?
    @NSManaged public var name: String?
    @NSManaged public var title: String?
    @NSManaged public var podcast: Podcast?

}
