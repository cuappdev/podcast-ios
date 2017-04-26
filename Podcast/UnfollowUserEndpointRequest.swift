//
//  UnfollowUserEndpointRequest.swift
//  Podcast
//
//  Created by Drew Dunne on 3/19/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class UnfollowUserEndpointRequest: EndpointRequest {
    
    // ID to unfollow
    var userID: String
    
    init(userID: String) {
        
        self.userID = userID
        
        super.init()
        
        path = "/followings/\(userID)" // NEEDS CHANGING probably
                
        httpMethod = .delete
        
    }
    
}
