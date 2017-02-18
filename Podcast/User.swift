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
    
    // TODO: Make this serializable and everything
    // TODO: Move session info into a session object
    
    static var user: User!
    
    /* Singleton */
    static var currentUser: User {
        if user == nil {
            user = User()
        }
        return user
    }
    
    /* Fill fields from a json */
    func fillFields(data: JSON) {
        fbID = data["user"]["fb_id"].string!
        sessionToken = data["session"]["token"].string!
    }
    
    /* Fields from the API */
    var fbID : String = ""
    var sessionToken : String = ""
    
    
    /* Arbitrary fields */
    var image: UIImage = UIImage(named: "filler_image")!
    var name: String = ""
    var username: String = ""
    var isFollowing: Bool = false
    var isMe: Bool = false
    var followersCount: Int = 0
    var followers: [User] = []
    var followingCount: Int = 0
    var following: [User] = []
    var subscriptions: [Series] = []
    var favorites: [Episode] = []
    
    
}
