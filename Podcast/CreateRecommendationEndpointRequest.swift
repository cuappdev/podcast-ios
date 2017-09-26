//
//  CreateRecommendationEndpointRequest.swift
//  Podcast
//
//  Created by Kevin Greer on 5/2/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import Foundation
import SwiftyJSON

class CreateRecommendationEndpointRequest: EndpointRequest {
    
    var episodeID: String
    
    init(episodeID: String) {
        self.episodeID = episodeID
        super.init()
        path = "/recommendations/\(episodeID)/"
        httpMethod = .post
    }
}
