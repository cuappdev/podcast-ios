//
//  Series.swift
//  Podcast
//
//  Created by Natasha Armbrust on 9/14/16.
//  Copyright © 2016 Cornell App Development. All rights reserved.
//

import UIKit
import SwiftyJSON

class Series: GridSeries {
    
    var episodes: [Episode]
    var author: String
    var descriptionText: String
    var tags: [Tag]
    var numberOfSubscribers: Int
    
    //dummy data only until we have real data
    convenience init(){
        self.init(id: "", title: "", author: "", descriptionText: "", smallArtworkImageURL: nil, largeArtworkImageURL: nil, tags: [], numberOfSubscribers: 0, isSubscribed: false, lastUpdated: Date())
    }
    
    //initializer with all atributes
    init(id: String, title: String, author: String, descriptionText: String, smallArtworkImageURL: URL?, largeArtworkImageURL: URL?, tags: [Tag], numberOfSubscribers: Int, isSubscribed: Bool, lastUpdated: Date) {
        self.author = author
        self.descriptionText = descriptionText
        self.numberOfSubscribers = numberOfSubscribers
        self.tags = tags
        self.episodes = []
        super.init(seriesId: id, userId: "", seriesTitle: title, smallArtworkImageURL: smallArtworkImageURL, largeArtworkImageURL: largeArtworkImageURL, isSubscribed: isSubscribed, lastUpdated: lastUpdated)
    }
    
     convenience init(json: JSON) {
        let id = json["id"].stringValue 
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
