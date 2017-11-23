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
            episodeJSON["current_progress"] = listeningDuration.currentProgress
            episodeJSON["percentage_listened"] = listeningDuration.percentageListened
            if let episode = Cache.sharedInstance.get(episode: id), !episode.isDurationWritten {
                episodeJSON["real_duration"] = listeningDuration.realDuration
            }
            params[id] = episodeJSON
        }
        bodyParameters = params
    }
}
