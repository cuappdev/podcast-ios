//
//  UserActivity.swift
//  Podcast
//
//  Created by Drew Dunne on 10/19/16.
//  Copyright © 2016 Cornell App Development. All rights reserved.
//

import UIKit

enum UserActivityAction {
    case Liked
    case Listened
}

class UserActivity: NSObject {
    
    var id: Int
    var episode: Episode
    var date: Date
    
    // This is temporary until can workout with 
    // backend how to represent an action
    var action: UserActivityAction
    
    init (id: Int, date: Double, epiID: Int) {
        self.id = id
        self.episode = Episode(id: epiID)
        self.action = .Liked
        self.date = Date(timeIntervalSince1970: date as TimeInterval)
    }
    
}
