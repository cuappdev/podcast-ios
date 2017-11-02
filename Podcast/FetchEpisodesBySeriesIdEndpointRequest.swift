//
//  EpisodesBySeriesIdEndpointRequest.swift
//  Podcast
//
//  Created by Natasha Armbrust on 3/30/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import SwiftyJSON

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
            Cache.sharedInstance.update(json: episode.1)
            //Episode(json: episode.1)
        }
    }
}
