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
    case followingRecommendation = "FOLLOWING_RECOMMENDATION" // following recommends a new episode
    case followingSubscription = "FOLLOWING_SUBSCRIPTION" // following subscribes to new series
    case newlyReleasedEpisode = "NEW_SUBSCRIBED_EPISODE" // series releases a new episode
}

class FeedElement: NSObject {
    
    var context: FeedContext // The type of FeedElement this object is
    var time: Date // The time at which the subject of this FeedElement was created
    var supplier: NSObject // The model that created this subject (ex: supplier = Series when context = .newlyReleasedEpisode)
    var subject: NSObject // The model holding the main information for this FeedElement (ex: subject = Episode when context = .newlyReleasedEpisode)
    
    init(context: FeedContext, time: Date, supplier: NSObject, subject: NSObject) {
        self.context = context
        self.time = time
        self.supplier = supplier
        self.subject = subject
        super.init()
    }
    
    convenience init?(json: JSON) {
        guard let context = FeedContext(rawValue: json["context"].stringValue) else { return nil }
        var supplier: NSObject
        var subject: NSObject
        switch context {
            case .followingRecommendation:
                supplier = User(json: json["context_supplier"])
                subject = Episode(json: json["content"])
            case .followingSubscription:
                supplier = User(json: json["context_supplier"])
                subject = Series(json: json["content"])
            case .newlyReleasedEpisode:
                supplier = Series(json: json["context_supplier"])
                subject = Episode(json: json["content"])
        }
            
        self.init(context: context,
                  time: Date(timeIntervalSince1970: json["time"].doubleValue),
                  supplier: supplier,
                  subject: subject)
    }
    
    override var hash: Int {
        var supplierID: String
        var subjectID: String
        switch context {
        case .followingRecommendation:
            supplierID = (supplier as! User).id
            subjectID = (subject as! Episode).id
        case .followingSubscription:
            supplierID = (supplier as! User).id
            subjectID = (subject as! Series).seriesId
        case .newlyReleasedEpisode:
            supplierID = (supplier as! Series).seriesId
            subjectID = (subject as! Episode).id
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
