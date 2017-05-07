//
//  CreateListeningHistoryElementEndpointRequest.swift
//  Podcast
//
//  Created by Kevin Greer on 5/7/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import Foundation
import SwiftyJSON

class CreateListeningHistoryElementEndpointRequest: EndpointRequest {
    
    var episodeID: String
    
    init(episodeID: String) {
        self.episodeID = episodeID
        super.init()
        path = "/history/listening/\(episodeID)"
        httpMethod = .post
    }
}
