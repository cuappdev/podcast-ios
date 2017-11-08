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
        // TODO: in future maybe store cache!
        episodeCache = [:]
        seriesCache = [:]
        userCache = [:]
    }
    
    func reset() {
        // TODO: this probably shouldn't be called. Gotta test what happens to views.
        // Possible error: the cache is reset, but views retain references to objects,
        // thus causing errors when cache is refilled. Views not flushed will be out
        // of sync with episodes loaded into reset cache from another view's endpoint
        // call. 
    }
    
    // Takes in episode JSON and adds/updates cache
    // Adds new if not present, updates cache if already present
    // ONLY should be called from endpoint requests!!!
    func update(episodeJson: JSON) -> Episode {
        let id = episodeJson["id"].stringValue
        if let episode = episodeCache[id] {
            // Update current episode object to maintain living object
            episode.update(json: episodeJson)
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
            series.update(json: seriesJson)
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
            user.update(json: userJson)
            return user
        } else {
            let user = User(json: userJson)
            userCache[id] = user
            return user
        }
    }
    
    // Use this to load an episode if needed (YOU SHOULDN'T HAVE TO)
    func get(episode id: String) -> Episode? {
        return episodeCache[id]
    }
    
    func get(series id: String) -> Series? {
        return seriesCache[id]
    }
    
    func get(user id: String) -> User? {
        return userCache[id]
    }
}
