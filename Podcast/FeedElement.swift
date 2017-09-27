//
//  FeedElement.swift
//  Podcast
//
//  Created by Kevin Greer on 9/27/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import Foundation
import SwiftyJson

enum FeedContext {
    case followingRecommendation = "FOLLOWING_RECOMMENDATION"
    case followingSubscription = "FOLLOWING_SUBSCRIPTION"
    case newlyReleasedEpisode = "NEW_SUBSCRIBED_EPISODE"
}

class FeedElement: NSObject {
    
    var context: FeedContext
    var time: Date
    var contextSupplier: NSObject
    var content: NSObject
    
    init(context: FeedContext, time: Date, contextSupplier: NSObject, content: NSObject) {
        self.context = context
        self.time = time
        self.contextSupplier = contextSupplier
        self.content = content
        super.init()
    }
    
    convenience init(json: JSON) {
        self.context = FeedContext(rawValue: json["context"].stringValue)
        self.time = Date(timeIntervalSince1970: json["time"].doubleValue)
        switch self.context {
        case followingRecommendation:
            self.contextSupplier = User(json: json["context_supplier"])
            self.content = Episode(json: json["content"])
        case followingSubscription:
            self.contextSupplier = User(json: json["context_supplier"])
            self.content = Series(json: json["content"])
        case newlyReleasedEpisode:
            self.contextSupplier = Series(json: json["context_supplier"])
            self.content = Episode(json: json["content"])
        }
    }
}
