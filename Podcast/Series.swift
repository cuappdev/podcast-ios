//
//  Series.swift
//  Podcast
//
//  Created by Natasha Armbrust on 9/14/16.
//  Copyright © 2016 Cornell App Development. All rights reserved.
//

import UIKit
import SwiftyJSON

class Series: NSObject {
    
    var seriesId: String
    var title: String
    var largeArtworkImageURL: URL?
    var smallArtworkImageURL: URL?
    var isSubscribed: Bool
    var lastUpdated: Date = Date() {
        didSet {
            lastUpdatedString = String(Date.formatDateDifferenceByLargestComponent(fromDate: lastUpdated, toDate: Date()))
        }
    }

    var lastUpdatedString: String = ""
    //var episodes: [Episode]
    var author: String
    var tags: [Tag] = [] {
        didSet {
            tagString = ""
            for (i,tag) in tags.enumerated() {
                if i == tags.count - 1 {
                    tagString += ", and "
                } else if i != 0 {
                    tagString += ", "
                }
                tagString += tag.name
            }
        }
    }

    var tagString = ""

    var numberOfSubscribers: Int
    
    //dummy data only until we have real data
    convenience override init(){
        self.init(id: "", title: "", author: "", smallArtworkImageURL: nil, largeArtworkImageURL: nil, tags: [], numberOfSubscribers: 0, isSubscribed: false, lastUpdated: Date())
    }
    
    //initializer with all atributes
    init(id: String, title: String, author: String, smallArtworkImageURL: URL?, largeArtworkImageURL: URL?, tags: [Tag], numberOfSubscribers: Int, isSubscribed: Bool, lastUpdated: Date) {
        self.author = author
        self.numberOfSubscribers = numberOfSubscribers
        //self.episodes = []
        self.seriesId = id
        self.title = title
        self.smallArtworkImageURL = smallArtworkImageURL
        self.largeArtworkImageURL = largeArtworkImageURL
        self.isSubscribed = isSubscribed

        super.init()

        // Makes sure didSet gets called during init
        defer {
            self.lastUpdated = lastUpdated
            self.tags = tags
        }
    }
    
     convenience init(json: JSON) {
        let seriesId = json["id"].stringValue
        let title = json["title"].stringValue
        let smallArtworkURL = URL(string: json["image_url_sm"].stringValue)
        let largeArtworkURL = URL(string: json["image_url_lg"].stringValue)
        let lastUpdatedString = json["last_updated"].stringValue
        let lastUpdated = DateFormatter.restAPIDateFormatter.date(from: lastUpdatedString) ?? Date()
        let author = json["author"].stringValue
        let isSubscribed = json["is_subscribed"].boolValue
        let numberOfSubscribers = json["subscribers_count"].intValue
        let tags = json["genres"].stringValue.components(separatedBy: ";").map({ tag in Tag(name: tag)})
        
        self.init(id: seriesId, title: title, author: author, smallArtworkImageURL: smallArtworkURL, largeArtworkImageURL: largeArtworkURL, tags: tags, numberOfSubscribers: numberOfSubscribers, isSubscribed: isSubscribed, lastUpdated: lastUpdated)
    }
    
    func update(json: JSON) {
        title = json["title"].stringValue
        smallArtworkImageURL = URL(string: json["image_url_sm"].stringValue)
        largeArtworkImageURL = URL(string: json["image_url_lg"].stringValue)
        let lastUpdatedString = json["last_updated"].stringValue
        lastUpdated = DateFormatter.restAPIDateFormatter.date(from: lastUpdatedString) ?? Date()
        author = json["author"].stringValue
        isSubscribed = json["is_subscribed"].boolValue
        numberOfSubscribers = json["subscribers_count"].intValue
        tags = json["genres"].stringValue.components(separatedBy: ";").map({ tag in Tag(name: tag)})
    }
    
    func subscriptionChange(completion: ((Bool, Int) -> ())? = nil) {
        isSubscribed ? unsubscribe(success: completion, failure: completion) : subscribe(success: completion, failure: completion)
    }
    
    func subscribe(success: ((Bool, Int) -> ())? = nil, failure: ((Bool, Int) -> ())? = nil) {
        let endpointRequest = CreateUserSubscriptionEndpointRequest(seriesID: seriesId)
        endpointRequest.success = { _ in
            self.isSubscribed = true
            self.numberOfSubscribers += 1
            success?(self.isSubscribed, self.numberOfSubscribers)
        }
        endpointRequest.failure = { _ in
            self.isSubscribed = false
            failure?(self.isSubscribed, self.numberOfSubscribers)
        }
        System.endpointRequestQueue.addOperation(endpointRequest)
    }
    
    func unsubscribe(success: ((Bool, Int) -> ())? = nil, failure: ((Bool, Int) -> ())? = nil) {
        let endpointRequest = DeleteUserSubscriptionEndpointRequest(seriesID: seriesId)
        endpointRequest.success = { _ in
            self.isSubscribed = false
            self.numberOfSubscribers -= 1
            success?(self.isSubscribed, self.numberOfSubscribers)
        }
        endpointRequest.failure = { _ in 
            self.isSubscribed = true
            failure?(self.isSubscribed, self.numberOfSubscribers)
        }
        System.endpointRequestQueue.addOperation(endpointRequest)
    }
}
