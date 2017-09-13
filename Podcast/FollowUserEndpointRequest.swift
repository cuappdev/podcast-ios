//
//  NewFollowingEndpointRequest.swift
//  Podcast
//
//  Created by Drew Dunne on 3/19/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class FollowUserEndpointRequest: EndpointRequest {
    
    // ID to follow
    var userID: Int
    
    init(userID: Int) {
        
        self.userID = userID
        
        super.init()
        
        path = "/followings/\(userID)/"
        
        httpMethod = .post
        
    }
    
}
