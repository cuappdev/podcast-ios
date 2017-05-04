//
//  FetchFeedEndpointRequest.swift
//  Podcast
//
//  Created by Natasha Armbrust on 5/4/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import SwiftyJSON

class FetchFeedEndpointRequest: EndpointRequest {
    
    var offset: Int
    var max: Int
    
    init(offset: Int, max: Int) {
        
        self.max = max
        self.offset = offset
        
        super.init()
        
        path = "/feed"
        httpMethod = .get
        queryParameters = ["max": max, "offset": offset]
    }
    
    override func processResponseJSON(_ json: JSON) {
        print(json)
        for episode in json["data"]["feeds"] {
            print(episode)
        }
        
    }
}
