//
//  FetchUserRecommendationsEndpointRequest.swift
//  Podcast
//
//  Created by Drew Dunne on 5/7/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import SwiftyJSON

class FetchUserRecommendationsEndpointRequest: EndpointRequest {
    var userID: String
    
    init(userID: String) {
        self.userID = userID
        
        super.init()
        
        path = "/recommendations/users/\(userID)/"
        
        httpMethod = .get
    }
    
    override func processResponseJSON(_ json: JSON) {
        var episodes: [Episode] = []
        json["data"]["recommendations"].forEach{ (_, episodeJson) in
            let episode = Cache.sharedInstance.update(episodeJson: episodeJson["episode"])
            UserEpisodeData.shared.update(with: episodeJson["blurb"].string, for: EpisodeToUser(episodeID: episode.id, userID: userID))
            episodes.append(episode)
        }
        processedResponseValue = episodes
    }
}
