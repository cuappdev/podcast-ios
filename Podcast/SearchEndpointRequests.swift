//
//  SearchEndpointRequests.swift
//  Podcast
//
//  Created by Jack Thompson on 8/27/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import Foundation
import SwiftyJSON

class SearchEndpointRequest: EndpointRequest {
    
    var query: String!
    var offset: Int!
    var max: Int!
    
    required init(modelPath: String = "", query: String, offset: Int = 0, max: Int = 0) {
        super.init()
        
        path = "/search/\(modelPath)/\(query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? query)/"
        
        httpMethod = .get
        
        queryParameters = ["offset": offset, "max": max]
    }
}

class SearchAllEndpointRequest: SearchEndpointRequest {
    
    required init(modelPath: String = "all", query: String, offset: Int, max: Int) {
        super.init(modelPath: modelPath, query: query, offset: offset, max: max)
    }
    
    override func processResponseJSON(_ json: JSON) {
        let episodes = json["data"]["episodes"].map{ episodeJSON in
            Cache.sharedInstance.update(episodeJson: episodeJSON.1)
        }
        let series = json["data"]["series"].map{ seriesJSON in
            Cache.sharedInstance.update(seriesJson: seriesJSON.1)
        }
        let users = json["data"]["users"].map{ userJSON in
            Cache.sharedInstance.update(userJson: userJSON.1)
            }.filter{
                $0.id != System.currentUser?.id
        }
        
        let results: [SearchType: [Any]] = [.episodes: episodes, .series: series, .people: users]
        processedResponseValue = results
    }
}

class SearchEpisodesEndpointRequest: SearchEndpointRequest {
    
    required init(modelPath: String = "episodes", query: String, offset: Int, max: Int) {
        super.init(modelPath: modelPath, query: query, offset: offset, max: max)
    }
    
    override func processResponseJSON(_ json: JSON) {
        processedResponseValue = json["data"]["episodes"].map{ episodeJSON in
            Cache.sharedInstance.update(episodeJson: episodeJSON.1)
        }
    }
}

class SearchSeriesEndpointRequest: SearchEndpointRequest {
    
    required init(modelPath: String = "series", query: String, offset: Int, max: Int) {
        super.init(modelPath: modelPath, query: query, offset: offset, max: max)
    }
    
    override func processResponseJSON(_ json: JSON) {
        processedResponseValue = json["data"]["series"].map{ seriesJSON in
            Cache.sharedInstance.update(seriesJson: seriesJSON.1)
        }
    }
}

class SearchUsersEndpointRequest: SearchEndpointRequest {
    
    required init(modelPath: String = "users", query: String, offset: Int, max: Int) {
        super.init(modelPath: modelPath, query: query, offset: offset, max: max)
    }
    
    override func processResponseJSON(_ json: JSON) {
        let users = json["data"]["users"].map{ (str, userJSON) in
            Cache.sharedInstance.update(userJson: userJSON)
        }
        processedResponseValue = users
    }
}

class SearchITunesEndpointRequest: EndpointRequest {
    
    let modelPath = "itunes"
    
    init(query: String) {
        super.init()
        path = "/search/\(modelPath)/\(query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? query)/"
        httpMethod = .post
    }
    
    override func processResponseJSON(_ json: JSON) {
        processedResponseValue = json["data"]["series"].map{ seriesJSON in
            Cache.sharedInstance.update(seriesJson: seriesJSON.1)
        }
    }
}


