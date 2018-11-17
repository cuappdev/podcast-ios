//
//  ITunesNamespace+CoreDataProperties.swift
//  
//
//  Created by Mindy Lou on 11/3/18.
//
//

import Foundation
import CoreData

enum PodcastType: String {
    case episodic, serial
}

enum EpisodeType: String {
    case full, trailer, bonus
}

extension ITunesNamespace: DisconnectedEntityProtocol {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ITunesNamespace> {
        return NSFetchRequest<ITunesNamespace>(entityName: "ITunesNamespace")
    }

    @NSManaged public var author: String?
    @NSManaged public var block: String?
    @NSManaged public var categories: [ITunesCategory]?
    @NSManaged public var complete: String?
    @NSManaged public var duration: Double
    @NSManaged public var episodeType: String?
    @NSManaged public var explicit: Bool
    @NSManaged public var image: URL?
    @NSManaged public var isClosedCaptioned: Bool
    @NSManaged public var keywords: String?
    @NSManaged public var podcastType: String?
    @NSManaged public var season: Int64
    @NSManaged public var subtitle: String?
    @NSManaged public var summary: String?
    @NSManaged public var newFeedUrl: String?
    @NSManaged public var owner: ITunesOwner?
    @NSManaged public var podcast: Podcast?
    @NSManaged public var episode: Episode?
    @NSManaged public var episodeNumber: Int64

    enum Keys: String {
        case author, block, categories, complete, duration, episodeNumber, episodeType, explicit, image, isClosedCaptioned, keywords, newFeedUrl, podcastType, season, subtitle, summary
        case episode, owner, podcast
    }

    func setValue(_ value: Any?, for key: Keys) {
        self.setValue(value, forKey: key.rawValue)
    }

}
