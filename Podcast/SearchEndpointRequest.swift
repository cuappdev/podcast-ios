//
//  SearchEndpointRequest.swift
//  Podcast
//
//  Created by Kevin Greer on 3/23/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchEndpointRequest: EndpointRequest {
    
    var query: String!
    var offset: Int!
    var max: Int!
    
    init(modelPath: String, query: String, offset: Int = 0, max: Int = 0) {
        super.init()
        
        path = "/search/\(modelPath)/\(query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? query)/"
        
        httpMethod = .get
        
        queryParameters = ["offset": offset, "max": max]
    }
}


