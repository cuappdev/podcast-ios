//
//  CurrentUser.swift
//  Podcast
//
//  Created by Natasha Armbrust on 3/1/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class CurrentUser: User {
    
    static var user: CurrentUser!
    
    /* Singleton */
    static var currentUser: CurrentUser {
        if user == nil {
            user = CurrentUser()
        }
        return user
    }
    
    var facebookID: String?
    var session: Session?
    
    init() {
        super.init(id: 0)
    }
    
    init(id: Int, name: String = "", username: String = "", imageURL: URL, numberOfFollowers: Int = 0, numberOfFollowing: Int = 0, sessionToken: String) {
        self.session = Session(sessionToken: sessionToken)
        super.init(id: id, name: name, username: username, imageURL: imageURL, numberOfFollowers: numberOfFollowers, numberOfFollowing: numberOfFollowing)
    }
    
    
}
