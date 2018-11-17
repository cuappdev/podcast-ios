//
//  Episode+CoreDataProperties.swift
//  
//
//  Created by Mindy Lou on 11/3/18.
//
//

import Foundation
import CoreData

extension Episode: DisconnectedEntityProtocol {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Episode> {
        return NSFetchRequest<Episode>(entityName: "Episode")
    }

    public class func fetchEpisodes(for podcast: Podcast) -> [Episode] {
        let fetchRequest: NSFetchRequest<Episode> = Episode.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "podcast.collectionId == %@", NSNumber(value: podcast.collectionId))
        do {
            let results = try AppDelegate.appDelegate.dataController.childManagedObjectContext.fetch(fetchRequest)
            return results
        } catch {
            let fetchError = error as NSError
            print("Error fetching data from context: \(fetchError)")
        }
        return []
    }

    @NSManaged public var author: String?
    @NSManaged public var categories: [String]?
    @NSManaged public var comments: String?
    @NSManaged public var content: String?
    @NSManaged public var descriptionText: String?
    @NSManaged public var guid: String?
    @NSManaged public var link: String?
    @NSManaged public var pubDate: NSDate?
    @NSManaged public var title: String?
    @NSManaged public var downloadInfo: DownloadInfo?
    @NSManaged public var enclosure: Enclosure?
    @NSManaged public var podcast: Podcast?
    @NSManaged public var source: ItemSource?
    @NSManaged public var iTunes: ITunesNamespace?

    enum Keys: String {
        case entityName = "Episode"
        case author, categories, comments, content, descriptionText, guid, id, link, pubDate, title
        case downloadInfo, enclosure, iTunes, podcast, source
    }

    func setValue(_ value: Any?, for key: Keys) {
        self.setValue(value, forKey: key.rawValue)
    }

    func addToContext() {
        let childMOC = AppDelegate.appDelegate.dataController.childManagedObjectContext
        childMOC.insert(self)

        if let enclosure = enclosure {
            childMOC.insert(enclosure)
        }
        if let iTunes = iTunes {
            childMOC.insert(iTunes)
        }
        if let owner = iTunes?.owner {
            childMOC.insert(owner)
        }
        if let source = source {
            childMOC.insert(source)
        }
    }
}
