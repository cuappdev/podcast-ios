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
    var user: User
    
    init(user: User) {
        self.user = user
        
        super.init()
        
        path = "/recommendations/users/\(user.id)/"
        
        httpMethod = .get
    }
    
    override func processResponseJSON(_ json: JSON) {
        var episodes: [Episode] = []
        json["data"]["recommendations"].forEach{ _, episodeJson in
            let episode = Cache.sharedInstance.update(episodeJson: episodeJson["episode"])
            UserEpisodeData.shared.update(with: episodeJson["blurb"].string, for: user, and: episode)
            episodes.append(episode)
        }
        processedResponseValue = episodes
    }
}
