//
//  FetchUserRecommendationsEndpointRequest.swift
//  Podcast
//
//  Created by Drew Dunne on 5/7/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import SwiftyJSON

class FetchUserRecommendationsEndpointRequest: EndpointRequest {
    var userID: String
    
    init(userID: String) {
        self.userID = userID
        
        super.init()
        
        path = "/recommendations/users/\(userID)/"
        
        httpMethod = .get
    }
    
    override func processResponseJSON(_ json: JSON) {
        processedResponseValue = json["data"]["recommendations"].map{ episode in
            Cache.sharedInstance.update(json: episode.1["episode"])
        }
    }
}
