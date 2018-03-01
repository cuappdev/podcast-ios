//
//  SearchITunesEndpointRequest.swift
//  Podcast
//
//  Created by Mindy Lou on 10/29/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import Foundation
import SwiftyJSON

class SearchITunesEndpointRequest: EndpointRequest {
    
    let modelPath = "itunes"
    
    init(query: String) {
        super.init()
        path = "/search/\(modelPath)/\(query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? query)/"
        httpMethod = .post
    }
    
    override func processResponseJSON(_ json: JSON) {
        processedResponseValue = json["data"]["series"].map{ seriesJSON in
            Cache.sharedInstance.update(seriesJson: seriesJSON.1)
        }
    }
}
