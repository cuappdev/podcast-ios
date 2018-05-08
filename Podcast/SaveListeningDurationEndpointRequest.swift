//
//  SaveListeningDurationEndpointRequest.swift
//  Podcast
//
//  Created by Natasha Armbrust on 11/19/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import Foundation
import SwiftyJSON

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
