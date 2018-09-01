//
//  SubscriptionsEndpointRequest.swift
//  Podcast
//
//  Created by Jack Thompson on 8/26/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class FetchSubscriptionsEndpointRequest: EndpointRequest {
    
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

class ModifySubscriptionEndpointRequest: EndpointRequest {
    
    var seriesID: String
    
    init(seriesID: String, method: HTTPMethod) {
        self.seriesID = seriesID
        super.init()
        
        path = "/subscriptions/\(seriesID)/"
        httpMethod = method
    }
}
