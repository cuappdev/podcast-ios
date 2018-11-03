//
//  Cloud+CoreDataProperties.swift
//  
//
//  Created by Mindy Lou on 11/1/18.
//
//

import Foundation
import CoreData


extension Cloud {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cloud> {
        return NSFetchRequest<Cloud>(entityName: "Cloud")
    }

    @NSManaged public var domain: String?
    @NSManaged public var path: String?
    @NSManaged public var portNumber: Int16
    @NSManaged public var protocolSpecification: String?
    @NSManaged public var registerProcedure: String?
    @NSManaged public var podcast: Podcast?

}
