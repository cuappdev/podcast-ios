//
//  Topic+CoreDataProperties.swift
//  
//
//  Created by Mindy Lou on 11/3/18.
//
//

import Foundation
import CoreData

extension Topic: DisconnectedEntityProtocol {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Topic> {
        return NSFetchRequest<Topic>(entityName: "Topic")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var podcast: Podcast?

    enum Keys: String {
        case id, name
        case podcast
    }

    func setValue(_ value: Any?, for key: Keys) {
        self.setValue(value, forKey: key.rawValue)
    }
}
