//
//  DeleteRecommendationEndpointRequest.swift
//  Podcast
//
//  Created by Kevin Greer on 5/2/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import Foundation
import SwiftyJSON

class DeleteRecommendationEndpointRequest: EndpointRequest {
    
    var episodeID: String
    
    init(episodeID: String) {
        self.episodeID = episodeID
        super.init()
        path = "/recommendations/\(episodeID)/"
        httpMethod = .delete
    }

    override func processResponseJSON(_ json: JSON) {
        let episode = Cache.sharedInstance.update(episodeJson: json["data"]["recommendation"]["episode"])
        UserEpisodeData.shared.updateBlurbForCurrentUser(with: json["data"]["recommendation"]["blurb"].string, and: episode)
    }
}
