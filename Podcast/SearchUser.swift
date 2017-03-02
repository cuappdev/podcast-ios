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
    var name: String = ""
    var isFollowing = false
    var numberOfFollowers = 0
    var username: String = ""
    var imageURL: URL?
    
    init(id: Int) {
        self.id = id
    }
    
    //init for all atributes
    init(id: Int, name: String = "", username: String = "", numberOfFollowers: Int = 0, imageURL: URL, isFollowing: Bool = false) {
        self.id = id
        self.name = name
        self.username = username
        self.imageURL = imageURL
        self.numberOfFollowers = numberOfFollowers
        self.isFollowing = isFollowing
        super.init()
    }
    
    //init without imageURL optional
    init(id: Int, name: String = "", username: String = "", numberOfFollowers: Int = 0, isFollowing: Bool = false) {
        self.id = id
        self.name = name
        self.username = username
        self.numberOfFollowers = numberOfFollowers
        self.isFollowing = isFollowing
        super.init()
    }
    
    
     convenience init(json: JSON) {
        let id = json["id"].int ?? 0
        let name = json["name"].string ?? ""
        let username = json["username"].string ?? ""
        let numberOfFollowers = json["n_followers"].int ?? 0
        let isFollowing = json["is_following"].bool ?? false
        
        if let imageURL = URL(string: json["image_url"].stringValue) {
            self.init(id: id, name: name, username: username, numberOfFollowers: numberOfFollowers, imageURL: imageURL, isFollowing: isFollowing)
        } else {
            self.init(id: id, name: name, username: username, numberOfFollowers: numberOfFollowers, isFollowing: isFollowing)
        }
     }
    
}
