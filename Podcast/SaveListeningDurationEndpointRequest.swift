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
        bodyParameters = [:]
        listeningDurations.forEach { (id, listeningDuration) in
            var episodeJSON: JSON = []
            if let episode = Cache.sharedInstance.get(episode: id), episode.isDurationWritten {
                episodeJSON = [
                    "current_progress": listeningDuration.currentProgress,
                    "percentage_listened": listeningDuration.percentageListened
                ]
            } else {
                episodeJSON = [
                    "real_duration": listeningDuration.realDuration,
                    "current_progress": listeningDuration.currentProgress,
                    "percentage_listened": listeningDuration.percentageListened
                ]
            }
            bodyParameters![id] = episodeJSON
        }
    }
}
