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
    
    var id: Int
    var firstName: String
    var lastName: String
    var username: String
    var numberOfFollowers: Int
    var numberOfFollowing: Int
    var favoriteEpisodes: [Episode]
    var subscriptions: [Series]
    var following: [User]
    var isFollowing: Bool
    var imageURL: URL?
    
    //dummy data init will delete later
    override convenience init() {
        self.init(id: 0, firstName: "", lastName: "", username: "", imageURL: nil, numberOfFollowers: 0, numberOfFollowing: 0, isFollowing: false)
    }
    
    //init with all atributes
    init(id: Int, firstName: String, lastName: String, username: String, imageURL: URL?, numberOfFollowers: Int, numberOfFollowing: Int, isFollowing: Bool) {
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
        let id = json["id"].intValue
        let firstName = json["firstName"].stringValue
        let lastName = json["lastName"].stringValue
        let username = json["username"].stringValue
        let numberOfFollowers = json["numberFollowers"].intValue
        let numberOfFollowing = json["numberFollowing"].intValue
        let isFollowing = json["isFollowing"].boolValue
        let imageURL = URL(string: json["imageURL"].stringValue)
        
        self.init(id: id, firstName: firstName, lastName: lastName, username: username, imageURL: imageURL, numberOfFollowers: numberOfFollowers, numberOfFollowing: numberOfFollowing, isFollowing: isFollowing)
    }
    
    func fullName() -> String {
        return "\(firstName) \(lastName)"
    }
}
