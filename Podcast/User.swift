//
//  User.swift
//  Podcast
//
//  Created by Natasha Armbrust on 9/14/16.
//  Copyright © 2016 Cornell App Development. All rights reserved.
//

import UIKit 

class User: NSObject {
    
    var image: UIImage = #imageLiteral(resourceName: "fillerImage")
    var name: String = ""
    var username: String = ""
    
    var isFollowing: Bool = false
    var isMe: Bool = false
    
    // Made these arrays for now, need discussion on our data types.
    var followersCount: Int = 0
    var followers: [User] = []
    
    var followingCount: Int = 0
    var following: [User] = []
    
    var subscriptions: [Series] = []
    var favorites: [Episode] = []
}
