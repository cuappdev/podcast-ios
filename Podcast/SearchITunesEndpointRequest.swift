//
//  SearchITunesEndpointRequest.swift
//  Podcast
//
//  Created by Mindy Lou on 10/29/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import Foundation
import SwiftyJSON

class SearchITunesEndpointRequest: SearchEndpointRequest {
    
    let modelPath = "itunes"
    
    init(query: String, offset: Int, max: Int) {
        super.init(modelPath: modelPath, query: query, offset: offset, max: max)
        httpMethod = .post
    }
    
    override func processResponseJSON(_ json: JSON) {
        processedResponseValue = json["data"]["series"].map{ seriesJSON in Series(json: seriesJSON.1) }
    }

}
