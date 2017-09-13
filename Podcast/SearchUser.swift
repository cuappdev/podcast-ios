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
    
    var id: String
    var firstName: String
    var lastName: String
    var isFollowing: Bool
    var numberOfFollowers: Int
    var username: String
    var imageURL: URL?

    
    //init for all atributes
    init(id: String, firstName: String, lastName: String, username: String, numberOfFollowers: Int, imageURL: URL?, isFollowing: Bool) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.imageURL = imageURL
        self.numberOfFollowers = numberOfFollowers
        self.isFollowing = isFollowing
        super.init()
    }
    
     convenience init(json: JSON) {
        let id = json["id"].stringValue
        let firstName = json["first_name"].stringValue
        let lastName = json["last_name"].stringValue
        let username = json["username"].stringValue
        let numberOfFollowers = json["n_followers"].intValue
        let isFollowing = json["is_following"].boolValue
        let imageURL = URL(string: json["image_url"].stringValue)
        
        self.init(id: id, firstName: firstName, lastName: lastName, username: username, numberOfFollowers: numberOfFollowers, imageURL: imageURL, isFollowing: isFollowing)
    }
    
}
