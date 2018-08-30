//
//  FacebookEndpointRequests.swift
//  Podcast
//
//  Created by Jack Thompson on 8/27/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import Foundation
import SwiftyJSON

class FetchFacebookFriendsEndpointRequest: EndpointRequest {
    
    var pageSize: Int
    var offset: Int
    // returnFollowing: If true, return your friends sorted by the number of followers.
    // If false, only return your friends that you are not following also sorted by the number of followers
    var returnFollowing: Bool?
    
    init(facebookAccessToken: String, pageSize: Int, offset: Int, returnFollowing: Bool?) {
        self.offset = offset
        self.pageSize = pageSize
        self.returnFollowing = returnFollowing
        super.init()
        
        path = "/users/facebook/friends/"
        httpMethod = .get
        queryParameters = ["offset": offset, "max": pageSize]
        
        if let following = returnFollowing {
            queryParameters["return_following"] = following.description
        }
        headers = ["AccessToken": facebookAccessToken]
    }
    
    override func processResponseJSON(_ json: JSON) {
        processedResponseValue = json["data"]["users"].map{ element in User(json: element.1) }
    }
}

class SearchFacebookFriendsEndpointRequest: EndpointRequest {
    
    var offset: Int
    var max: Int
    var query: String
    
    init(facebookAccessToken: String, query: String, offset: Int, max: Int) {
        self.query = query
        self.offset = offset
        self.max = max
        super.init()
        
        path = "/search/facebook/friends/\(query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? query)/"
        httpMethod = .get
        queryParameters = ["offset": offset, "max": max]
        headers = ["AccessToken": facebookAccessToken]
    }
    
    override func processResponseJSON(_ json: JSON) {
        processedResponseValue = json["data"]["users"].map{ element in User(json: element.1) }
    }
}

class DismissFacebookFriendEndpointRequest: EndpointRequest {
    
    // id of the friend we are dismissing
    var facebookId: String
    
    init(facebookAccessToken: String, facebookId: String) {
        self.facebookId = facebookId
        super.init()
        
        path = "/users/facebook/friends/ignore/\(facebookId)/"
        httpMethod = .post
        headers = ["AccessToken": facebookAccessToken]
    }
}
