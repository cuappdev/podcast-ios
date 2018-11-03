//
//  ITunesNamespace+CoreDataProperties.swift
//  
//
//  Created by Mindy Lou on 11/1/18.
//
//

import Foundation
import CoreData


extension ITunesNamespace {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ITunesNamespace> {
        return NSFetchRequest<ITunesNamespace>(entityName: "ITunesNamespace")
    }

    @NSManaged public var author: String?
    @NSManaged public var block: String?
    @NSManaged public var categories: [ITunesCategory]?
    @NSManaged public var complete: String?
    @NSManaged public var duration: Double
    @NSManaged public var episode: Int64
    @NSManaged public var episodeType: Int64
    @NSManaged public var explicit: Bool
    @NSManaged public var image: URL?
    @NSManaged public var isClosedCaptioned: Bool
    @NSManaged public var keywords: String?
    @NSManaged public var order: Int64
    @NSManaged public var podcastType: Int64
    @NSManaged public var season: Int64
    @NSManaged public var subtitle: String?
    @NSManaged public var summary: String?
    @NSManaged public var theNewFeedUrl: String?
    @NSManaged public var owner: ITunesOwner?

}
