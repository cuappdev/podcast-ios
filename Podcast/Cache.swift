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
    private var seriesCache: [String: Series]!
    private var userCache: [String: User]!
    
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
    func update(episodeJson: JSON) -> Episode {
        let id = episodeJson["id"].stringValue
        if let episode = episodeCache[id] {
            // Update current episode object to maintain living object
            episode.title = episodeJson["title"].stringValue
            episode.descriptionText = episodeJson["summary"].stringValue
            episode.isRecommended = episodeJson["is_recommended"].boolValue
            episode.isBookmarked = episodeJson["is_bookmarked"].boolValue
            episode.numberOfRecommendations = episodeJson["recommendations_count"].intValue
            episode.seriesTitle = episodeJson["series"]["title"].stringValue
            episode.seriesID = episodeJson["series"]["id"].stringValue
            episode.duration = episodeJson["duration"].stringValue
            episode.tags = episodeJson["tags"].stringValue.components(separatedBy: ";").map({ tag in Tag(name: tag) })
            episode.audioURL = URL(string: episodeJson["audio_url"].stringValue)
            episode.dateCreated = DateFormatter.parsingDateFormatter.date(from: episodeJson["pub_date"].stringValue) ?? Date()
            episode.smallArtworkImageURL = URL(string: episodeJson["series"]["image_url_sm"].stringValue)
            episode.largeArtworkImageURL = URL(string: episodeJson["series"]["image_url_lg"].stringValue)
            return episode
        } else {
            let episode = Episode(json: episodeJson)
            episodeCache[id] = episode
            return episode
        }
    }
    
    func update(seriesJson: JSON) -> Series {
        let id = seriesJson["id"].stringValue
        if let series = seriesCache[id] {
            series.title = seriesJson["title"].stringValue
            series.smallArtworkImageURL = URL(string: seriesJson["image_url_sm"].stringValue)
            series.largeArtworkImageURL = URL(string: seriesJson["image_url_lg"].stringValue)
            let lastUpdatedString = seriesJson["last_updated"].stringValue
            series.lastUpdated = DateFormatter.parsingDateFormatter.date(from: lastUpdatedString) ?? Date()
            series.author = seriesJson["author"].stringValue
            series.isSubscribed = seriesJson["is_subscribed"].boolValue
            series.numberOfSubscribers = seriesJson["subscribers_count"].intValue
            series.tags = seriesJson["genres"].stringValue.components(separatedBy: ";").map({ tag in Tag(name: tag)})
            return series
        } else {
            let series = Series(json: seriesJson)
            seriesCache[id] = series
            return series
        }
    }
    
    func update(userJson: JSON) -> User {
        let id = userJson["id"].stringValue
        if let user = userCache[id] {
            user.firstName = userJson["first_name"].stringValue
            user.lastName = userJson["last_name"].stringValue
            user.username = userJson["username"].stringValue
            user.numberOfFollowers = userJson["followers_count"].intValue
            user.numberOfFollowing = userJson["followings_count"].intValue
            user.isFollowing = userJson["is_following"].boolValue
            user.imageURL = URL(string: userJson["image_url"].stringValue)
            return user
        } else {
            let user = User(json: userJson)
            userCache[id] = user
            return user
        }
    }
    
    // Use this to load an episode if needed (YOU SHOULDN'T HAVE TO)
    func load(episode id: String) -> Episode? {
        return episodeCache[id]
    }
}
