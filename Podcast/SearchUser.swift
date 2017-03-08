//
//  SearchUser.swift
//  Podcast
//
//  Created by Natasha Armbrust on 3/1/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchUser: NSObject {
    
    var id: Int
    var name: String
    var isFollowing: Bool
    var numberOfFollowers: Int
    var username: String
    var imageURL: URL?

    
    //init for all atributes
    init(id: Int, name: String, username: String, numberOfFollowers: Int, imageURL: URL?, isFollowing: Bool) {
        self.id = id
        self.name = name
        self.username = username
        self.imageURL = imageURL
        self.numberOfFollowers = numberOfFollowers
        self.isFollowing = isFollowing
        super.init()
    }
    
     convenience init(json: JSON) {
        let id = json["id"].intValue
        let name = json["name"].stringValue
        let username = json["username"].stringValue
        let numberOfFollowers = json["n_followers"].intValue
        let isFollowing = json["is_following"].boolValue
        let imageURL = URL(string: json["image_url"].stringValue)
        
        self.init(id: id, name: name, username: username, numberOfFollowers: numberOfFollowers, imageURL: imageURL, isFollowing: isFollowing)
    }
    
}
