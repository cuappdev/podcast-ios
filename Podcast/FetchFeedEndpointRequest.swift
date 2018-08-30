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
    
    var pageSize: Int
    var maxtime: Int
    
    init(maxtime: Int, pageSize: Int) {
        self.maxtime = maxtime
        self.pageSize = pageSize
        super.init()
        
        path = "/feed/"
        httpMethod = .get
        queryParameters = ["maxtime": maxtime, "page_size": pageSize]
    }
    
    override func processResponseJSON(_ json: JSON) {
        processedResponseValue = json["data"]["feed"].map{ element in FeedElement(json: element.1) }
    }
}
