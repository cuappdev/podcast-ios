//
//  FetchByIDEndpointRequests.swift
//  Podcast
//
//  Created by Jack Thompson on 8/27/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import Foundation
import SwiftyJSON

class FetchSeriesForSeriesIDEndpointRequest: EndpointRequest {
    
    var seriesID: String
    
    init(seriesID: String) {
        self.seriesID = seriesID
        super.init()
        
        path = "/series/\(seriesID)/"
        httpMethod = .get
    }
    
    override func processResponseJSON(_ json: JSON) {
        processedResponseValue = Cache.sharedInstance.update(seriesJson: json["data"]["series"])
    }
}

class FetchEpisodesForSeriesIDEndpointRequest: EndpointRequest {
    
    var seriesID: String
    var offset: Int
    var max: Int
    
    init(seriesID: String, offset: Int, max: Int) {
        
        self.seriesID = seriesID
        self.offset = offset
        self.max = max
        
        super.init()
        
        path = "/podcasts/episodes/by_series/\(seriesID)/"
        
        httpMethod = .get
        
        queryParameters = ["max": max, "offset": offset]
    }
    
    override func processResponseJSON(_ json: JSON) {
        processedResponseValue = json["data"]["episodes"].map{ episode in
            Cache.sharedInstance.update(episodeJson: episode.1)
        }
    }
}

class FetchUserByIDEndpointRequest: EndpointRequest {
    
    // ID to fetch
    var userID: String
    
    init(userID: String) {
        
        self.userID = userID
        
        super.init()
        
        path = "/users/\(userID)/"
        
        httpMethod = .get
        
    }
    
    override func processResponseJSON(_ json: JSON) {
        let user = Cache.sharedInstance.update(userJson: json["data"]["user"])
        processedResponseValue = user
    }
}
