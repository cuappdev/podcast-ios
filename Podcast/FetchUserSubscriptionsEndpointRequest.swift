//
//  FetchUserSubscriptionsEndpointRequest.swift
//  Podcast
//
//  Created by Natasha Armbrust on 4/1/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import SwiftyJSON

class FetchUserSubscriptionsEndpointRequest: EndpointRequest {
    
    var userID: String
    
    init(userID: String) {
        self.userID = userID
        super.init()
        path = "/subscriptions"
        httpMethod = .get
        queryParameters = ["id": userID]
    }
    
    override func processResponseJSON(_ json: JSON) {
        processedResponseValue = json["data"]["subscriptions"].map{ series in SubscriptionSeries(json: series.1) }
    }
}
