//
//  FetchUserFollowersByIDRequest.swift
//  Podcast
//
//  Created by Drew Dunne on 9/13/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import SwiftyJSON

enum UserFollowsType {
    case Followers
    case Followings
    
    var key: String {
        return self == .Followers ? "followers" : "followings"
    }
    
    var userKey: String {
        return self == .Followers ? "follower" : "followed"
    }
}

class FetchUserFollowsByIDRequest: EndpointRequest {
    
    var userId: String
    var type: UserFollowsType
    
    init(userId: String, type: UserFollowsType) {
        
        self.userId = userId
        self.type = type
        super.init()
        
        path = type == .Followers ? "/followers/show/\(userId)/" : "/followings/show/\(userId)/"
        httpMethod = .get
    }
    
    override func processResponseJSON(_ json: JSON) {
        //don't really need these b/c same user,session returned
        let isMe = userId == System.currentUser?.id
        let followsJSON = json["data"][type.key]
        var users: [User] = []
        for followJSON in followsJSON {
            let userJSON = followJSON.1[type.userKey]
            let user = User(json: userJSON)
            if type == .Followings && isMe {
                user.isFollowing = true
            }
            users.append(user)
        }
        processedResponseValue = users
    }

}
