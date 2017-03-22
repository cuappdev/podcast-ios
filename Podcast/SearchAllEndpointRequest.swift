//
//  SearchAllEndpointRequest.swift
//  Podcast
//
//  Created by Kevin Greer on 3/14/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchAllEndpointRequest: EndpointRequest {
    
    init(query: String, offset: Int, max: Int) {
        super.init()
        
        path = "/search/all/\(query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? query)"
        
        httpMethod = .get
        
        queryParameters = ["offset": offset, "max": max]
    }
    
    override func processResponseJSON(_ json: JSON) {
        let episodes = json["data"]["episodes"].map{ episodeJson in Episode(json: episodeJson.1) }
        let series = json["data"]["series"].map{ episodeJson in Series(json: episodeJson.1) }
        let users = json["data"]["users"].map{ episodeJson in User(json: episodeJson.1) }
        let results: [SearchType: [Any]] = [.episodes: episodes, .series: series, .people: users]
        processedResponseValue = results
    }
}
