//
//  CreateUserSubscriptionEndpointRequest.swift
//  Podcast
//
//  Created by Natasha Armbrust on 3/30/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import SwiftyJSON

class CreateUserSubscriptionEndpointRequest: EndpointRequest {
    
    var seriesID: String 
    
    init(seriesID: String) {
        
        self.seriesID = seriesID
        
        super.init()
        
        path = "/subscriptions"
        
        httpMethod = .post
        
        queryParameters = ["series_id": seriesID]
    }
}
