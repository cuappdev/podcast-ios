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
    var tags: [Tag]
    var numberOfSubscribers: Int
    
    //dummy data only until we have real data
    convenience init(){
        self.init(id: "", title: "", author: "", smallArtworkImageURL: nil, largeArtworkImageURL: nil, tags: [], numberOfSubscribers: 0, isSubscribed: false, lastUpdated: Date())
    }
    
    //initializer with all atributes
    init(id: String, title: String, author: String, smallArtworkImageURL: URL?, largeArtworkImageURL: URL?, tags: [Tag], numberOfSubscribers: Int, isSubscribed: Bool, lastUpdated: Date) {
        self.author = author
        self.numberOfSubscribers = numberOfSubscribers
        self.tags = tags
        self.episodes = []
        super.init(seriesId: id, userId: "", seriesTitle: title, smallArtworkImageURL: smallArtworkImageURL, largeArtworkImageURL: largeArtworkImageURL, isSubscribed: isSubscribed, lastUpdated: lastUpdated)
    }
    
     convenience init(json: JSON) {
        let id = json["id"].stringValue 
        let title = json["title"].stringValue
        let author = json["author"].stringValue
        let isSubscribed = json["is_subscribed"].boolValue
        let numberOfSubscribers = json["subscribers_count"].intValue
        let tags = json["genres"].stringValue.components(separatedBy: ";").map({ tag in Tag(name: tag)})
        let smallArtworkURL = URL(string: json["image_url_sm"].stringValue)
        let largeArtworkURL = URL(string: json["image_url_lg"].stringValue)
        let lastUpdatedString = json["last_updated"].stringValue
        let lastUpdated = DateFormatter.parsingDateFormatter.date(from: lastUpdatedString) ?? Date()
        
        self.init(id: id, title: title, author: author, smallArtworkImageURL: smallArtworkURL, largeArtworkImageURL: largeArtworkURL, tags: tags, numberOfSubscribers: numberOfSubscribers, isSubscribed: isSubscribed, lastUpdated: lastUpdated)
    }
}
