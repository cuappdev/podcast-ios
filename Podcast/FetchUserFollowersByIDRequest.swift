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
}

class FetchUserFollowsByIDRequest: EndpointRequest {
    
    var userId: String
    var type: UserFollowsType
    
    init(userId: String, type: UserFollowsType) {
        
        self.userId = userId
        self.type = type
        super.init()
        
        path = type == .Followers ? "/followers/show/\(userId)/" : "/followings/show/\(userId)/"
        //"followings/show?id=id"
        httpMethod = .get
        //queryParameters = ["id": userId]
    }
    
    override func processResponseJSON(_ json: JSON) {
        //don't really need these b/c same user,session returned
        let key = type == .Followers ? "followers" : "followings"
        let userKey = type == .Followers ? "follower" : "followed"
        let followsJSON = json["data"][key]
        var users: [User] = []
        for followJSON in followsJSON {
            //print("FollowJSON: \n\(followJSON.1[0])")
            let userJSON = followJSON.1[0][userKey]
            //print(userJSON)
            let user = User(json: userJSON)
            users.append(user)
        }
        processedResponseValue = users
    }

}
