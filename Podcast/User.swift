//
//  User.swift
//  Podcast
//
//  Created by Natasha Armbrust on 9/14/16.
//  Copyright © 2016 Cornell App Development. All rights reserved.
//

import UIKit 
import SwiftyJSON

class User: NSObject {
    
    var id: String
    var firstName: String
    var lastName: String
    var username: String
    var numberOfFollowers: Int
    var numberOfFollowing: Int
    var favoriteEpisodes: [Episode]?
    var subscriptions: [Series]?
    var following: [User]
    var isFollowing: Bool
    var imageURL: URL?
    
    //dummy data init will delete later
    override convenience init() {
        self.init(id: "", firstName: "", lastName: "", username: "", imageURL: nil, numberOfFollowers: 0, numberOfFollowing: 0, isFollowing: false)
    }
    
    //init with all atributes
    init(id: String, firstName: String, lastName: String, username: String, imageURL: URL?, numberOfFollowers: Int, numberOfFollowing: Int, isFollowing: Bool) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.imageURL = imageURL
        self.numberOfFollowers = numberOfFollowers
        self.numberOfFollowing = numberOfFollowing
        self.isFollowing = isFollowing
        self.favoriteEpisodes = []
        self.following = []
        self.subscriptions = []
    }
    
    convenience init(json: JSON) {
        let id = json["id"].stringValue
        let firstName = json["first_name"].stringValue
        let lastName = json["last_name"].stringValue
        let username = json["username"].stringValue
        let numberOfFollowers = json["number_followers"].intValue
        let numberOfFollowing = json["number_following"].intValue
        let isFollowing = json["is_following"].boolValue
        let imageURL = URL(string: json["image_url"].stringValue)
        
        self.init(id: id, firstName: firstName, lastName: lastName, username: username, imageURL: imageURL, numberOfFollowers: numberOfFollowers, numberOfFollowing: numberOfFollowing, isFollowing: isFollowing)
    }
    
    func fullName() -> String {
        return "\(firstName) \(lastName)"
    }
}
