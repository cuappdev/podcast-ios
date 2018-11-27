//
//  Podcast+CoreDataProperties.swift
//  
//
//  Created by Mindy Lou on 11/3/18.
//
//

import Foundation
import CoreData

extension Podcast {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Podcast> {
        return NSFetchRequest<Podcast>(entityName: "Podcast")
    }

    @NSManaged public var artistName: String?
    @NSManaged public var artworkUrl30: URL?
    @NSManaged public var artworkUrl60: URL?
    @NSManaged public var artworkUrl100: URL?
    @NSManaged public var artworkUrl600: URL?
    @NSManaged public var categories: [String]?
    @NSManaged public var collectionExplicitness: String?
    @NSManaged public var collectionId: Int64
    @NSManaged public var collectionName: String?
    @NSManaged public var copyright: String?
    @NSManaged public var descriptionText: String?
    @NSManaged public var docs: String?
    @NSManaged public var feedUrl: URL?
    @NSManaged public var generator: String?
    @NSManaged public var genreIds: [String]?
    @NSManaged public var genres: [String]?
    @NSManaged public var image: URL?
    @NSManaged public var language: String?
    @NSManaged public var lastBuildDate: NSDate?
    @NSManaged public var link: String?
    @NSManaged public var managingEditor: String?
    @NSManaged public var primaryGenreName: String?
    @NSManaged public var pubDate: NSDate?
    @NSManaged public var rating: String?
    @NSManaged public var rawSkipDays: [String]?
    @NSManaged public var skipHours: [Int64]?
    @NSManaged public var title: String?
    @NSManaged public var ttl: Int64
    @NSManaged public var webMaster: String?
    @NSManaged public var items: NSOrderedSet?
    @NSManaged public var iTunes: ITunesNamespace?
    @NSManaged public var textInput: TextInput?
    @NSManaged public var topics: NSSet?

    enum Keys: String {
        case artistName, artworkUrl30, artworkUrl60, artworkUrl100, artworkUrl600, categories, collectionExplicitness, collectionId, collectionName, copyright, descriptionText, docs, feedUrl, generator, genreIds, genres, image, language, lastBuildDate, link, managingEditor, primaryGenreName, pubDate, rating, rawSkipDays, skipHours, title, ttl, webMaster
        case items, iTunes, textInput, topics
    }

    func setValue(_ value: Any?, for key: Keys) {
        self.setValue(value, forKey: key.rawValue)
    }
}

// MARK: Generated accessors for items
extension Podcast {

    @objc(insertObject:inItemsAtIndex:)
    @NSManaged public func insertIntoItems(_ value: Episode, at idx: Int)

    @objc(removeObjectFromItemsAtIndex:)
    @NSManaged public func removeFromItems(at idx: Int)

    @objc(insertItems:atIndexes:)
    @NSManaged public func insertIntoItems(_ values: [Episode], at indexes: NSIndexSet)

    @objc(removeItemsAtIndexes:)
    @NSManaged public func removeFromItems(at indexes: NSIndexSet)

    @objc(replaceObjectInItemsAtIndex:withObject:)
    @NSManaged public func replaceItems(at idx: Int, with value: Episode)

    @objc(replaceItemsAtIndexes:withItems:)
    @NSManaged public func replaceItems(at indexes: NSIndexSet, with values: [Episode])

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: Episode)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: Episode)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSOrderedSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSOrderedSet)

}

// MARK: Generated accessors for topics
extension Podcast {

    @objc(addTopicsObject:)
    @NSManaged public func addToTopics(_ value: Topic)

    @objc(removeTopicsObject:)
    @NSManaged public func removeFromTopics(_ value: Topic)

    @objc(addTopics:)
    @NSManaged public func addToTopics(_ values: NSSet)

    @objc(removeTopics:)
    @NSManaged public func removeFromTopics(_ values: NSSet)

}
