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
    case followingShare(User, Episode) // following personally shares an episode

    static func from(json: JSON) -> FeedContext? {
        guard let contextString = json["context"].string else { return nil }
        switch contextString {
        case "FOLLOWING_RECOMMENDATION":
            let user = Cache.sharedInstance.update(userJson: json["context_supplier"])
            let episode = Cache.sharedInstance.update(episodeJson: json["content"])
            UserEpisodeData.shared.update(with: json["blurb"].string, for: EpisodeToUser(episodeID: episode.id, userID: user.id))
            return .followingRecommendation(user, episode)
        case "FOLLOWING_SUBSCRIPTION":
            return .followingSubscription(
                Cache.sharedInstance.update(userJson: json["context_supplier"]),
                Cache.sharedInstance.update(seriesJson: json["content"]))
        case "NEW_SUBSCRIBED_EPISODE":
            return .newlyReleasedEpisode(
                Cache.sharedInstance.update(seriesJson: json["context_supplier"]),
                Cache.sharedInstance.update(episodeJson: json["content"]))
        case "SHARED_EPISODE":
            return .followingShare(
                Cache.sharedInstance.update(userJson: json["context_supplier"]),
                Cache.sharedInstance.update(episodeJson: json["content"]))
        default: return nil
        }
    }

    var supplier: NSObject {
        switch self {
        case .followingRecommendation(let supplier, _):
            return supplier
        case .followingSubscription(let supplier, _):
            return supplier
        case .newlyReleasedEpisode(let supplier, _):
            return supplier
        case .followingShare(let supplier, _):
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
        case .followingShare(_, let subject):
            return subject
        }
    }

    var cellType: FeedElementTableViewCell.Type {
        switch self {
        case .newlyReleasedEpisode, .followingShare:
            return FeedEpisodeTableViewCell.self
        case .followingSubscription:
            return FeedSeriesTableViewCell.self
        case .followingRecommendation:
            return FeedRecastTableViewCell.self
        }
    }
}

class FeedElement: NSObject {

    var id: String? // the id of the feed element (neccesary for deleting of shared episodes)
    var context: FeedContext // The type of FeedElement this object is
    var time: Date = Date() // The time at which the subject of this FeedElement was created
    
    init(context: FeedContext, time: Date) {
        self.context = context
        self.time = time
        super.init()
    }
    
    init?(json: JSON) {
        guard let context = FeedContext.from(json: json) else { return nil }
        self.context = context

        if let time = json["time"].double {
            self.time = Date(timeIntervalSince1970: time)
        }

        if let id = json["id"].int {
            self.id = String(describing: id)
        }
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
        case let .followingShare(user, episode):
            supplierID = user.id
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
