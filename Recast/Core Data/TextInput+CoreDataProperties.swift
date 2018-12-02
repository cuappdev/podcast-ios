//
//  TextInput+CoreDataProperties.swift
//  
//
//  Created by Mindy Lou on 11/3/18.
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

    enum Keys: String {
        case descriptionText, link, name, title
        case podcast
    }

    func setValue(_ value: Any?, for key: Keys) {
        self.setValue(value, forKey: key.rawValue)
    }

}
