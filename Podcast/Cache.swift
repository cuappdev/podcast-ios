//
//  Cache.swift
//  Podcast
//
//  Created by Drew Dunne on 11/1/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import SwiftyJSON

class Cache: NSObject {
    static let sharedInstance = Cache()
    
    // NOTE: We might want to thing about limiting cache size in the future,
    // but not something to worry about now. 
    private var episodeCache: [String: Episode]!
    private var seriesCache: [String: Episode]!
    private var usersCache: [String: Episode]!
    
    private override init() {
        episodeCache = [:] // TODO: in future maybe store cache!
    }
    
    func reset() {
        // TODO: this probably shouldn't be called. Gotta test what happens to views.
        // Possible error: the cache is reset, but views retain references to objects,
        // thus causing errors when cache is refilled. Views not flushed will be out
        // of sync with episodes loaded into reset cache from another view's endpoint
        // call. 
        episodeCache = [:]
    }
    
    // Takes in episode JSON and adds/updates cache
    // Adds new if not present, updates cache if already present
    // ONLY should be called from endpoint requests!!!
    func update(json: JSON) -> Episode {
        let id = json["id"].stringValue
        if let episode = episodeCache[id] {
            // Update current episode object to maintain living object
            episode.title = json["title"].stringValue
            episode.descriptionText = json["summary"].stringValue
            episode.isRecommended = json["is_recommended"].boolValue
            episode.isBookmarked = json["is_bookmarked"].boolValue
            episode.numberOfRecommendations = json["recommendations_count"].intValue
            episode.seriesTitle = json["series"]["title"].stringValue
            episode.seriesID = json["series"]["id"].stringValue
            episode.duration = json["duration"].stringValue
            episode.tags = json["tags"].stringValue.components(separatedBy: ";").map({ tag in Tag(name: tag) })
            episode.audioURL = URL(string: json["audio_url"].stringValue)
            episode.dateCreated = DateFormatter.parsingDateFormatter.date(from: json["pub_date"].stringValue) ?? Date()
            episode.smallArtworkImageURL = URL(string: json["series"]["image_url_sm"].stringValue)
            episode.largeArtworkImageURL = URL(string: json["series"]["image_url_lg"].stringValue)
            return episode
        } else {
            let episode = Episode(json: json)
            episodeCache[id] = episode
            return episode
        }
    }
    
    // Use this to load an episode if needed (YOU SHOULDN'T HAVE TO)
    func load(episode id: String) -> Episode? {
        return episodeCache[id]
    }
}
