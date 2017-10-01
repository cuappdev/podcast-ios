//
//  FetchListeningHistoryEndpointRequest.swift
//  Podcast
//
//  Created by Kevin Greer on 5/7/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import Foundation
import SwiftyJSON

class FetchListeningHistoryEndpointRequest: EndpointRequest {
    
    var offset: Int!
    var max: Int!
    
    init(offset: Int, max: Int) {
        super.init()
        path = "/history/listening/"
        httpMethod = .get
        queryParameters = ["offset": offset, "max": max]
    }
    
    override func processResponseJSON(_ json: JSON) {
        processedResponseValue = json["data"]["listening_histories"].map{ episodeJosn in Episode(json: episodeJosn.1["episode"]) }
    }
}
