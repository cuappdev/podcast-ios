//
//  SearchSeries.swift
//  Podcast
//
//  Created by Natasha Armbrust on 3/1/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchSeries: NSObject {
    
    var id: Int
    var title: String = ""
    var smallArtworkImageURL: URL?
    var smallArtworkImage: UIImage?
    var numberOfSubscribers: Int = 0
    var isSubscribed = false
    var author: String = ""
    
    
    init(id: Int) {
        self.id = id
    }
    
    //init with all atributes
    init(id: Int, title: String = "", author: String = "", smallArtworkImageURL: URL, isSubscribed: Bool = false, numberOfSubscribers: Int = 0) {
        self.id = id
        self.title = title
        self.smallArtworkImageURL = smallArtworkImageURL
        self.author = author
        self.isSubscribed = isSubscribed
        self.numberOfSubscribers = numberOfSubscribers
        super.init()
    }
    
    //init without smallArtworkImageURL optional
    init(id: Int, title: String = "", author: String = "", isSubscribed: Bool = false, numberOfSubscribers: Int = 0) {
        self.id = id
        self.title = title
        self.author = author
        self.isSubscribed = isSubscribed
        self.numberOfSubscribers = numberOfSubscribers
        super.init()
    }
    
    
     convenience init(json: JSON) {
        let id = json["id"].int ?? 0
        let title = json["title"].string ?? ""
        let author = json["author"].string ?? ""
        let isSubscribed = json["is_subscribed"].bool ?? false
        let numberOfSubscribers = json["n_subscribers"].int ?? 0
        
        if let imageURL = URL(string: json["small_image_url"].stringValue) {
            self.init(id: id, title: title, author: author, smallArtworkImageURL: imageURL, isSubscribed: isSubscribed, numberOfSubscribers: numberOfSubscribers)
        } else {
            self.init(id: id, title: title, author: author, numberOfSubscribers: numberOfSubscribers)
        }
     }
    
}
