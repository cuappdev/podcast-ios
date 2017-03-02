//
//  SearchUser.swift
//  Podcast
//
//  Created by Natasha Armbrust on 3/1/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

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
    
    init(id: Int, name: String = "", username: String = "", numberOfFollowers: Int = 0, imageURL: URL, isFollowing: Bool = false) {
        self.id = id
        self.name = name
        self.username = username
        self.imageURL = imageURL
        self.numberOfFollowers = numberOfFollowers
        self.isFollowing = isFollowing
        super.init()
    }
    
    /*
     convenience init(_json: JSON) {
     //TODO: make these consistent with backend
     
     //self.init( ... )
     }
     */
}
