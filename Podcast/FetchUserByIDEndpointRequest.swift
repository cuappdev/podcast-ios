//
//  UserEndpointRequest.swift
//  Podcast
//
//  Created by Drew Dunne on 3/15/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import SwiftyJSON

class FetchUserByIDEndpointRequest: EndpointRequest {
    
    // ID to fetch
    var userID: String
    
    init(userID: String) {
        
        self.userID = userID
        
        super.init()
        
        path = "/users/\(userID)/"
        
        httpMethod = .get
        
    }
    
    override func processResponseJSON(_ json: JSON) {
        let user = Cache.sharedInstance.update(userJson: json["data"]["user"])
        processedResponseValue = user
    }
}
