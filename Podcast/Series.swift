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
    
    var id: Int
    var title: String
    var episodes: [Episode]
    var author: String
    var descriptionText: String
    var smallArtworkImageURL: URL?
    var largeArtworkImageURL: URL?
    var tags: [Tag]
    var numberOfSubscribers: Int
    var isSubscribed: Bool
    var lastUpdated: Date
    
    //dummy data only until we have real data
    override convenience init(){
        self.init(id: 0, title: "", author: "", descriptionText: "", smallArtworkImageURL: nil, largeArtworkImageURL: nil, tags: [], numberOfSubscribers: 0, isSubscribed: false, lastUpdated: Date())
    }
    
    //initializer with all atributes
    init(id: Int, title: String, author: String, descriptionText: String, smallArtworkImageURL: URL?, largeArtworkImageURL: URL?, tags: [Tag], numberOfSubscribers: Int, isSubscribed: Bool, lastUpdated: Date) {
    
        self.id = id
        self.title = title
        self.author = author
        self.descriptionText = descriptionText
        self.smallArtworkImageURL = smallArtworkImageURL
        self.largeArtworkImageURL = largeArtworkImageURL
        self.numberOfSubscribers = numberOfSubscribers
        self.isSubscribed = isSubscribed
        self.tags = tags
        self.episodes = []
        self.lastUpdated = lastUpdated
        super.init()
    }
    
     convenience init(json: JSON) {
        let id = json["id"].intValue
        let title = json["title"].stringValue
        let author = json["author"].stringValue
        let descriptionText = json["summary"].stringValue
        let isSubscribed = json["isSubscribed"].boolValue
        let numberOfSubscribers = json["nSubscribers"].intValue
        let tags = json["genres"].arrayValue.map({ (tag: JSON) in Tag(name: tag.stringValue) })
        let lastUpdatedString = json["lastUpdated"].stringValue
        let lastUpdated = DateFormatter.parsingDateFormatter.date(from: lastUpdatedString) ?? Date()
        let smallArtworkURL = URL(string: json["imageUrlSm"].stringValue)
        let largeArtworkURL = URL(string: json["imageUrlLg"].stringValue)
        self.init(id: id, title: title, author: author, descriptionText: descriptionText, smallArtworkImageURL: smallArtworkURL, largeArtworkImageURL: largeArtworkURL, tags: tags, numberOfSubscribers: numberOfSubscribers, isSubscribed: isSubscribed, lastUpdated: lastUpdated)
    }
}
