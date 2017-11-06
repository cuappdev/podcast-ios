//
//  FeedElement.swift
//  Podcast
//
//  Created by Kevin Greer on 9/27/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import Foundation
import SwiftyJSON

enum FeedContext {
    case followingRecommendation(User, Episode) // following recommends a new episode
    case followingSubscription(User, Series)    // following subscribes to new series
    case newlyReleasedEpisode(Series, Episode)  // series releases a new episode

    var supplier: NSObject {
        switch self {
        case .followingRecommendation(let supplier, _):
            return supplier
        case .followingSubscription(let supplier, _):
            return supplier
        case .newlyReleasedEpisode(let supplier, _):
            return supplier
        }
    }

    var subject: NSObject {
        switch self {
        case .followingRecommendation(_, let subject):
            return subject
        case .followingSubscription(_, let subject):
            return subject
        case .newlyReleasedEpisode(_, let subject):
            return subject
        }
    }
}

class FeedElement: NSObject {
    
    var context: FeedContext // The type of FeedElement this object is
    var time: Date // The time at which the subject of this FeedElement was created
    
    init(context: FeedContext, time: Date) {
        self.context = context
        self.time = time
        super.init()
    }
    
    init?(json: JSON) {
        guard let contextString = json["context"].string,
            let date = json["time"].double else { return nil }

        switch contextString {
        case "FOLLOWING_RECOMMENDATION":
            context = .followingRecommendation(
                Cache.sharedInstance.update(userJson: json["context_supplier"]),
                Cache.sharedInstance.update(episodeJson: json["content"]))
        case "FOLLOWING_SUBSCRIPTION":
            context = .followingSubscription(
                Cache.sharedInstance.update(userJson: json["context_supplier"]),
                Cache.sharedInstance.update(seriesJson: json["content"]))
        case "NEW_SUBSCRIBED_EPISODE":
            context = .newlyReleasedEpisode(
                Cache.sharedInstance.update(seriesJson: json["context_supplier"]),
                Cache.sharedInstance.update(episodeJson: json["content"]))
        default: return nil
        }

        time = Date(timeIntervalSince1970: date)
    }
    
    override var hash: Int {
        var supplierID: String
        var subjectID: String
        switch context {
        case let .followingRecommendation(user, episode):
            supplierID = user.id
            subjectID = episode.id
        case let .followingSubscription(user, series):
            supplierID = user.id
            subjectID = series.seriesId
        case let .newlyReleasedEpisode(series, episode):
            supplierID = series.seriesId
            subjectID = episode.id
        }
        
        guard let supplierIDUnwrapped = Int(supplierID), let subjectIDUnwrapped = Int(subjectID) else { return 0 }
        return supplierIDUnwrapped + subjectIDUnwrapped
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        if let feedElement = object as? FeedElement {
            return self.hashValue == feedElement.hashValue
        }
        return false
    }
}
