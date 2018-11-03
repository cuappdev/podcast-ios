//
//  Episode+CoreDataProperties.swift
//  
//
//  Created by Mindy Lou on 11/1/18.
//
//

import Foundation
import CoreData


extension Episode {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Episode> {
        return NSFetchRequest<Episode>(entityName: "Episode")
    }

    @NSManaged public var author: String?
    @NSManaged public var categories: [String]?
    @NSManaged public var comments: String?
    @NSManaged public var content: String?
    @NSManaged public var descriptionText: String?
    @NSManaged public var guid: String?
    @NSManaged public var id: String?
    @NSManaged public var link: String?
    @NSManaged public var pubDate: NSDate?
    @NSManaged public var title: String?
    @NSManaged public var downloadInfo: DownloadInfo?
    @NSManaged public var enclosure: Enclosure?
    @NSManaged public var podcast: Podcast?
    @NSManaged public var source: ItemSource?

}
