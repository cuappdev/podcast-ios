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
    var title: String = ""
    var episodes: [Episode] = []
    var author: String = ""
    var descriptionText: String = ""
    var smallArtworkImageURL: URL?
    var largeArtworkImageURL: URL?
    var smallArtworkImage: UIImage?
    var largeArtworkImage: UIImage?
    var tags: [Tag] = []
    var numberOfSubscribers: Int = 0
    var isSubscribed = false
    
    init(id: Int) {
        self.id = id
    }
    
    //initializer with all atributes
    init(id: Int, title: String = "", author: String = "", descriptionText: String = "", smallArtworkImageURL: URL, largeArtworkImageURL: URL, tags: [Tag] = [], numberOfSubscribers: Int = 0, isSubscribed: Bool = false) {
    
        self.id = id
        self.title = title
        self.author = author
        self.descriptionText = descriptionText
        self.smallArtworkImageURL = smallArtworkImageURL
        self.largeArtworkImageURL = largeArtworkImageURL
        self.numberOfSubscribers = numberOfSubscribers
        self.isSubscribed = isSubscribed
        self.tags = tags
        super.init()
    }
    
    //initalizer without small/largeArtworkImageURL optional
    init(id: Int, title: String = "", author: String = "", descriptionText: String = "", tags: [Tag] = [], numberOfSubscribers: Int = 0, isSubscribed: Bool = false) {
        
        self.id = id
        self.title = title
        self.author = author
        self.descriptionText = descriptionText
        self.numberOfSubscribers = numberOfSubscribers
        self.isSubscribed = isSubscribed
        self.tags = tags
        super.init()
    }
    
    
     convenience init(json: JSON) {
        let id = json["id"].int ?? 0
        let title = json["title"].string ?? ""
        let author = json["author"].string ?? ""
        let descriptionText = json["description"].string ?? ""
        let isSubscribed = json["is_subscribed"].bool ?? false
        let numberOfSubscribers = json["n_subscribers"].int ?? 0
        let tags = json["tags"].arrayValue.map({ (tag: JSON) in Tag(name: tag.stringValue) })
        
        if let smallArtworkURL = URL(string: json["small_image_url"].stringValue), let largeArtworkURL = URL(string: json["large_image_url"].stringValue) {
            self.init(id: id, title: title, author: author, descriptionText: descriptionText, smallArtworkImageURL: smallArtworkURL, largeArtworkImageURL: largeArtworkURL, tags: tags, numberOfSubscribers: numberOfSubscribers, isSubscribed: isSubscribed)
        } else {
            self.init(id: id, title: title, author: author, descriptionText: descriptionText, tags: tags, numberOfSubscribers: numberOfSubscribers, isSubscribed: isSubscribed)
        }
     }
    
    
    
    func fetchEpisodes() {
        episodes = [] 
    }
}
