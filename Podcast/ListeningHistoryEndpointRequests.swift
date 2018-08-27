//
//  ListeningHistoryEndpointRequests.swift
//  Podcast
//
//  Created by Jack Thompson on 8/27/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import Foundation
import SwiftyJSON

class FetchListeningHistoryEndpointRequest: EndpointRequest {
    
    var offset: Int
    var max: Int
    
    //dismissed is an optional argument that if supplied will filter the
    // listening history such that all returned listening history entries have their dismissed value equal to the supplied value.
    var dismissed: Bool?
    
    init(offset: Int, max: Int, dismissed: Bool? = nil) {
        self.offset = offset
        self.max = max
        self.dismissed = dismissed
        
        super.init()
        path = "/history/listening/"
        httpMethod = .get
        queryParameters = ["offset": offset, "max": max]
        if let dismiss = dismissed {
            queryParameters!["dismissed"] = encodeBoolean(dismiss)
        }
    }
    
    override func processResponseJSON(_ json: JSON) {
        processedResponseValue = json["data"]["listening_histories"].map{ episodeJosn in
            Cache.sharedInstance.update(episodeJson: episodeJosn.1["episode"])
        }
    }
}

class DeleteListeningHistoryElementEndpointRequest: EndpointRequest {
    
    var episodeID: String
    
    init(episodeID: String) {
        self.episodeID = episodeID
        super.init()
        path = "/history/listening/\(episodeID)/"
        httpMethod = .delete
    }
}

class SaveListeningDurationEndpointRequest: EndpointRequest {
    
    var listeningDurations: [String: ListeningDuration]
    
    init(listeningDurations: [String: ListeningDuration]) {
        self.listeningDurations = listeningDurations
        super.init()
        path = "/history/listening/"
        httpMethod = .post
        var params: [String: Any] = [:]
        listeningDurations.forEach { (id, listeningDuration) in
            var episodeJSON: [String:Any] = [:]
            if let currentProgress = listeningDuration.currentProgress {
                episodeJSON["current_progress"] = currentProgress
            }
            
            if let duration = listeningDuration.realDuration {
                episodeJSON["real_duration"] = duration
            }
            
            episodeJSON["percentage_listened"] = listeningDuration.percentageListened
            
            params[id] = episodeJSON
        }
        bodyParameters = params
    }
}

class DismissCurrentListeningHistoryEndpointRequest: EndpointRequest {
    
    var episodeID: String
    var dismissed: Bool?
    
    // dismissed is an optional boolean argument.
    // Supplying true will dismiss the episode and supplying false will un-dismiss it. Supplying no argument defaults to true.
    
    init(episodeID: String, dismissed: Bool? = nil) {
        self.episodeID = episodeID
        self.dismissed = dismissed
        
        super.init()
        path = "/history/listening/dismiss/\(episodeID)/"
        if let dismiss = dismissed {
            queryParameters = ["dismissed": encodeBoolean(dismiss)]
        }
        httpMethod = .post
    }
}
