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
    var name: String = ""
    var username: String = ""
    var imageURL: URL?
    var numberOfFollowers: Int = 0
    var numberOfFollowing: Int = 0
    var favoriteEpisodes: [Episode] = []
    var subscriptions: [Series] = []
    var following: [User] = []
    var isFollowing = false
    var image: UIImage?
    
    init(id: Int) {
        self.id = id
    }
    
    init(id: Int, name: String = "", username: String = "", imageURL: URL, numberOfFollowers: Int = 0, numberOfFollowing: Int = 0, isFollowing: Bool = false) {
        self.id = id
        self.name = name
        self.username = username
        self.imageURL = imageURL
        self.numberOfFollowers = numberOfFollowers
        self.numberOfFollowing = numberOfFollowing
        self.isFollowing = isFollowing
    }
}
