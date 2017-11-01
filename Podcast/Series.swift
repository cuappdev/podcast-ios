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
    var lastUpdated: Date
    var episodes: [Episode]
    var author: String
    var tags: [Tag]
    var numberOfSubscribers: Int
    
    //dummy data only until we have real data
    convenience override init(){
        self.init(id: "", title: "", author: "", smallArtworkImageURL: nil, largeArtworkImageURL: nil, tags: [], numberOfSubscribers: 0, isSubscribed: false, lastUpdated: Date())
    }
    
    //initializer with all atributes
    init(id: String, title: String, author: String, smallArtworkImageURL: URL?, largeArtworkImageURL: URL?, tags: [Tag], numberOfSubscribers: Int, isSubscribed: Bool, lastUpdated: Date) {
        self.author = author
        self.numberOfSubscribers = numberOfSubscribers
        self.tags = tags
        self.episodes = []
        self.seriesId = id
        self.title = title
        self.smallArtworkImageURL = smallArtworkImageURL
        self.largeArtworkImageURL = largeArtworkImageURL
        self.isSubscribed = isSubscribed
        self.lastUpdated = lastUpdated
    }
    
     convenience init(json: JSON) {
        let seriesId = json["id"].stringValue
        let title = json["title"].stringValue
        let smallArtworkURL = URL(string: json["image_url_sm"].stringValue)
        let largeArtworkURL = URL(string: json["image_url_lg"].stringValue)
        let lastUpdatedString = json["last_updated"].stringValue
        let lastUpdated = DateFormatter.parsingDateFormatter.date(from: lastUpdatedString) ?? Date()
        let author = json["author"].stringValue
        let isSubscribed = json["is_subscribed"].boolValue
        let numberOfSubscribers = json["subscribers_count"].intValue
        let tags = json["genres"].stringValue.components(separatedBy: ";").map({ tag in Tag(name: tag)})
        
        self.init(id: seriesId, title: title, author: author, smallArtworkImageURL: smallArtworkURL, largeArtworkImageURL: largeArtworkURL, tags: tags, numberOfSubscribers: numberOfSubscribers, isSubscribed: isSubscribed, lastUpdated: lastUpdated)
    }
    
    func allTags() -> String {
        var tagString = ""
        for (i,tag) in tags.enumerated() {
            if i == tags.count - 1 {
                tagString += ", and "
            } else if i != 0 {
                tagString += ", "
            }
            tagString += tag.name
        }
        return tagString
    }
    
    func lastUpdatedAsString() -> String {
        return String(Date.formatDateDifferenceByLargestComponent(fromDate: lastUpdated, toDate: Date()))
    }
    
    func didSubscribe() {
        if !isSubscribed {
            self.isSubscribed = true
            self.numberOfSubscribers += 1
        }
    }
    
    func didUnsubscribe() {
        if isSubscribed {
            self.isSubscribed = false
            self.numberOfSubscribers -= 1
        }
    }
}
