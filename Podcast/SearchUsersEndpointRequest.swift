//
//  SearchUsersEndpointRequest.swift
//  Podcast
//
//  Created by Kevin Greer on 3/18/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchUsersEndpointRequest: SearchEndpointRequest {
    
    let modelPath = "users"
    
    init(query: String, offset: Int, max: Int) {
        super.init(modelPath: modelPath, query: query, offset: offset, max: max)
    }
    
    override func processResponseJSON(_ json: JSON) {
        processedResponseValue = json["data"]["users"].map{ userJSON in User(json: userJSON.1) }
    }
}

