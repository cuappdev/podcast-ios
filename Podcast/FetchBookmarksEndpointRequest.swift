//
//  FetchBookmarksEndpointRequest.swift
//  Podcast
//
//  Created by Kevin Greer on 4/29/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import Foundation
import SwiftyJSON

class FetchBookmarksEndpointRequest: EndpointRequest {
    
    override init() {
        super.init()
        path = "/bookmarks"
        httpMethod = .get
    }
    
    override func processResponseJSON(_ json: JSON) {
        processedResponseValue = json["data"]["bookmarks"].map{ series in Episode(json: series.1) }
    }
}
