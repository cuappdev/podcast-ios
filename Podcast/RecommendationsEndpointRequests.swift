//
//  RecommendationsEndpointRequests.swift
//  Podcast
//
//  Created by Jack Thompson on 8/27/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import Foundation
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

class CreateRecommendationEndpointRequest: EndpointRequest {
    
    var episodeID: String
    
    init(episodeID: String, with blurb: String? = nil) {
        self.episodeID = episodeID
        super.init()
        path = "/recommendations/\(episodeID)/"
        httpMethod = .post
        
        if let addedBlurb = blurb {
            bodyParameters = ["blurb": addedBlurb]
        }
    }
    
    override func processResponseJSON(_ json: JSON) {
        let episode = Cache.sharedInstance.update(episodeJson: json["data"]["recommendation"]["episode"])
        UserEpisodeData.shared.updateBlurbForCurrentUser(with: json["data"]["recommendation"]["blurb"].string, and: episode)
    }
}

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

