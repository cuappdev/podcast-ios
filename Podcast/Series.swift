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
    var lastUpdated: Date? {
        didSet {
            if let updated = lastUpdated {
                lastUpdatedString = String(Date.formatDateDifferenceByLargestComponent(fromDate: updated, toDate: Date()))
            }
        }
    }

    var lastUpdatedString: String = ""
    //var episodes: [Episode]
    var author: String
    var topics: [Topic] = [] {
        didSet {
            topicString = ""
            if topics.count == 1 { topicString += topics[0].name }
            else {
                for (i,topic) in topics.enumerated() {
                    if i == topics.count - 1 {
                        topicString += topics.count == 2 ? " and " : ", and "
                    } else if i != 0 {
                        topicString += ", "
                    }
                    topicString += topic.name
                }
            }
        }
    }

    var topicString = ""

    var numberOfSubscribers: Int
    var receivesNotifications: Bool = false // TODO: endpoint
    
    //dummy data only until we have real data
    convenience override init(){
        self.init(id: "", title: "", author: "", smallArtworkImageURL: nil, largeArtworkImageURL: nil, topics: [], numberOfSubscribers: 0, isSubscribed: false, lastUpdated: Date())
    }
    
    //initializer with all atributes
    init(id: String, title: String, author: String, smallArtworkImageURL: URL?, largeArtworkImageURL: URL?, topics: [Topic], numberOfSubscribers: Int, isSubscribed: Bool, lastUpdated: Date?) {
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
            self.topics = topics
        }
    }
    
     convenience init(json: JSON) {
        let seriesId = json["id"].stringValue
        let title = json["title"].stringValue
        let smallArtworkURL = URL(string: json["image_url_sm"].stringValue)
        let largeArtworkURL = URL(string: json["image_url_lg"].stringValue)
        let lastUpdatedString = json["last_updated"].stringValue
        let lastUpdated = DateFormatter.restAPIDateFormatter.date(from: lastUpdatedString)
        let author = json["author"].stringValue
        let isSubscribed = json["is_subscribed"].boolValue
        let numberOfSubscribers = json["subscribers_count"].intValue
        let topics = json["genres"].stringValue.components(separatedBy: ";")
            .map({ topic in Topic(name: topic)})
            .filter { topic -> Bool in topic.name != "Podcasts" }

        self.init(id: seriesId, title: title, author: author, smallArtworkImageURL: smallArtworkURL, largeArtworkImageURL: largeArtworkURL, topics: topics, numberOfSubscribers: numberOfSubscribers, isSubscribed: isSubscribed, lastUpdated: lastUpdated)
    }
    
    func update(json: JSON) {
        title = json["title"].stringValue
        smallArtworkImageURL = URL(string: json["image_url_sm"].stringValue)
        largeArtworkImageURL = URL(string: json["image_url_lg"].stringValue)
        let lastUpdatedString = json["last_updated"].stringValue
        lastUpdated = DateFormatter.restAPIDateFormatter.date(from: lastUpdatedString)
        author = json["author"].stringValue
        isSubscribed = json["is_subscribed"].boolValue
        numberOfSubscribers = json["subscribers_count"].intValue
        topics = Series.createTopics(names: json["genres"].stringValue.components(separatedBy: ";"))
    }
    
    static func createTopics(names: [String]) -> [Topic] {
        var topics: [Topic] = []
        for topic in names {
            if topic != "Podcasts" { topics.append(Topic(name: topic)) }
        }
        return topics
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
            self.receivesNotifications = false
            success?(self.isSubscribed, self.numberOfSubscribers)
        }
        endpointRequest.failure = { _ in 
            self.isSubscribed = true
            failure?(self.isSubscribed, self.numberOfSubscribers)
        }
        System.endpointRequestQueue.addOperation(endpointRequest)
    }

    func notificationChange(uponStart: (() -> ())? = nil, uponStop: (() -> ())? = nil, failure: (() -> ())? = nil) {
        receivesNotifications ? stopReceivingNotifications(success: uponStop, failure: failure) : receiveNotifications(success: uponStart, failure: failure)
    }

    func receiveNotifications(success: (() -> ())? = nil, failure: (() -> ())? = nil) {
        // TODO
        let endpointRequest = OptInNotificationsForSeriesEndpointRequest(seriesID: seriesId)
        endpointRequest.success = { _ in
            self.receivesNotifications = true
            success?()
        }
        endpointRequest.failure = { _ in
            self.receivesNotifications = false
            failure?()
        }
        System.endpointRequestQueue.addOperation(endpointRequest)
    }

    func stopReceivingNotifications(success: (() -> ())? = nil, failure: (() -> ())? = nil) {
        let endpointRequest = OptOutNotificationsForSeriesEndpointRequest(seriesID: seriesId)
        endpointRequest.success = { _ in
            self.receivesNotifications = false
            success?()
        }
        endpointRequest.failure = { _ in
            self.receivesNotifications = true
            failure?()
        }
        System.endpointRequestQueue.addOperation(endpointRequest)
    }
}
