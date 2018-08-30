//
//  UserSubscriptionsEndpointRequest.swift
//  Podcast
//
//  Created by Jack Thompson on 8/26/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import Foundation
import SwiftyJSON

class FetchUserSubscriptionsEndpointRequest: EndpointRequest {
    
    var userID: String
    
    init(userID: String) {
        self.userID = userID
        super.init()
        
        path = "/subscriptions/users/\(userID)/"
        httpMethod = .get
    }
    
    override func processResponseJSON(_ json: JSON) {
        let series = json["data"]["subscriptions"].map{ jsons -> Series in
            return Cache.sharedInstance.update(seriesJson: jsons.1["series"])
        }
        processedResponseValue = series
    }
}

class CreateUserSubscriptionEndpointRequest: EndpointRequest {
    
    var seriesID: String
    
    init(seriesID: String) {
        self.seriesID = seriesID
        super.init()
        
        path = "/subscriptions/\(seriesID)/"
        httpMethod = .post
    }
}

class DeleteUserSubscriptionEndpointRequest: EndpointRequest {
    
    var seriesID: String
    
    init(seriesID: String) {
        self.seriesID = seriesID
        super.init()
        
        path = "/subscriptions/\(seriesID)/"
        httpMethod = .delete
    }
}
