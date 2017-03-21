//
//  SearchAllEndpointRequest.swift
//  Podcast
//
//  Created by Kevin Greer on 3/14/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchAllEndpointRequest: SearchEndpointRequest {
    
    init(query: String, offset: Int, max: Int) {
        super.init()
        
        path = "/search/all/\(query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? query)"
        
        httpMethod = .get
        
        queryParameters = ["offset": offset, "max": max]
        
        failure = { request in
            print("all failure")
        }
        
        print(urlString(), queryParameters)
    }
    
    override func processResponseJSON(_ json: JSON) {
        print(json)
    }
}
