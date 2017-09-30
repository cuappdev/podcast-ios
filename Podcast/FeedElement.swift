//
//  FeedElement.swift
//  Podcast
//
//  Created by Kevin Greer on 9/27/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import Foundation
import SwiftyJSON

enum FeedContext: String {
    case followingRecommendation = "FOLLOWING_RECOMMENDATION"
    case followingSubscription = "FOLLOWING_SUBSCRIPTION"
    case newlyReleasedEpisode = "NEW_SUBSCRIBED_EPISODE"
}

class FeedElement: NSObject {
    
    var context: FeedContext // The type of FeedElement this object is
    var time: Date // The time at which the content of this FeedElement was created
    var contextSupplier: NSObject // The model that created this content
    var content: NSObject // The model holding the main information for this FeedElement
    
    init(context: FeedContext, time: Date, contextSupplier: NSObject, content: NSObject) {
        self.context = context
        self.time = time
        self.contextSupplier = contextSupplier
        self.content = content
        super.init()
    }
    
    convenience init(json: JSON) {
        var contextSupplier: NSObject
        var content: NSObject
        let context = FeedContext(rawValue: json["context"].stringValue)!
        switch context {
        case .followingRecommendation:
            contextSupplier = User(json: json["context_supplier"])
            content = Episode(json: json["content"])
        case .followingSubscription:
            contextSupplier = User(json: json["context_supplier"])
            content = Series(json: json["content"])
        case .newlyReleasedEpisode:
            contextSupplier = Series(json: json["context_supplier"])
            content = Episode(json: json["content"])
        }
        self.init(context: FeedContext(rawValue: json["context"].stringValue)!,
                  time: Date(timeIntervalSince1970: json["time"].doubleValue),
                  contextSupplier: contextSupplier,
                  content: content)
    }
}
