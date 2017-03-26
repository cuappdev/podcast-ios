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
    var title: String
    var smallArtworkImageURL: URL?
    var numberOfSubscribers: Int
    var isSubscribed: Bool
    var author: String
    
    //init with all atributes
    init(id: Int, title: String, author: String, smallArtworkImageURL: URL?, isSubscribed: Bool, numberOfSubscribers: Int) {
        self.id = id
        self.title = title
        self.smallArtworkImageURL = smallArtworkImageURL
        self.author = author
        self.isSubscribed = isSubscribed
        self.numberOfSubscribers = numberOfSubscribers
        super.init()
    }
    
    
     convenience init(json: JSON) {
        let id = json["id"].intValue
        let title = json["title"].stringValue
        let author = json["author"].stringValue
        let isSubscribed = json["isSubscribed"].boolValue
        let numberOfSubscribers = json["nSubscribers"].intValue
        let imageURL = URL(string: json["imageUrlSm"].stringValue)
        
        self.init(id: id, title: title, author: author, smallArtworkImageURL: imageURL, isSubscribed: isSubscribed, numberOfSubscribers: numberOfSubscribers)
     }
    
}
