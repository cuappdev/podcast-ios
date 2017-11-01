//
//  SearchAllEndpointRequest.swift
//  Podcast
//
//  Created by Natasha Armbrust on 10/4/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//
import UIKit
import SwiftyJSON

class SearchAllEndpointRequest: SearchEndpointRequest {
    
    let modelPath = "all"
    
    init(query: String, offset: Int, max: Int) {
        super.init(modelPath: modelPath, query: query, offset: offset, max: max)
    }
    
    override func processResponseJSON(_ json: JSON) {
        let episodes = json["data"]["episodes"].map{ episodeJSON in Episode(json: episodeJSON.1) }
        let series = json["data"]["series"].map{ seriesJSON in Series(json: seriesJSON.1) }
        
        var users: [User] = []
        json["data"]["users"].forEach { (s,json) in
            let user = User(json: json)
            //don't show yourself in search results 
            if user.id != System.currentUser?.id {
                users.append(user)
            }
        }
        let results: [SearchType: [Any]] = [.episodes: episodes, .series: series, .itunes: [], .people: users]
        processedResponseValue = results
    }
}

