//
//  FollowsEndpointRequest.swift
//  Podcast
//
//  Created by Jack Thompson on 8/26/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import Foundation
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
            let user = Cache.sharedInstance.update(userJson: userJSON)
            if type == .Followings && isMe {
                user.isFollowing = true
            }
            users.append(user)
        }
        processedResponseValue = users
    }
    
}

class FollowUserEndpointRequest: EndpointRequest {
    
    // ID to follow
    var userID: String
    
    init(userID: String) {
        self.userID = userID
        super.init()
        
        path = "/followings/\(userID)/"
        httpMethod = .post
    }
}

class UnfollowUserEndpointRequest: EndpointRequest {
    
    // ID to unfollow
    var userID: String
    
    init(userID: String) {
        self.userID = userID
        super.init()
        
        path = "/followings/\(userID)/"
        httpMethod = .delete
    }
    
}
