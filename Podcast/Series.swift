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
    
    //dummy data only until we have real data
    override convenience init(){
        self.init(id: 0, title: "", author: "", descriptionText: "", smallArtworkImageURL: nil, largeArtworkImageURL: nil, tags: [], numberOfSubscribers: 0, isSubscribed: false)
    }
    
    //initializer with all atributes
    init(id: Int, title: String, author: String, descriptionText: String, smallArtworkImageURL: URL?, largeArtworkImageURL: URL?, tags: [Tag], numberOfSubscribers: Int, isSubscribed: Bool) {
    
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
        super.init()
    }
    
     convenience init(json: JSON) {
        let id = json["id"].intValue
        let title = json["title"].stringValue
        let author = json["author"].stringValue
        let descriptionText = json["description"].stringValue
        let isSubscribed = json["is_subscribed"].boolValue
        let numberOfSubscribers = json["n_subscribers"].intValue
        let tags = json["tags"].arrayValue.map({ (tag: JSON) in Tag(name: tag.stringValue) })
        
        let smallArtworkURL = URL(string: json["small_image_url"].stringValue)
        let largeArtworkURL = URL(string: json["large_image_url"].stringValue)
        self.init(id: id, title: title, author: author, descriptionText: descriptionText, smallArtworkImageURL: smallArtworkURL, largeArtworkImageURL: largeArtworkURL, tags: tags, numberOfSubscribers: numberOfSubscribers, isSubscribed: isSubscribed)
    }
}
