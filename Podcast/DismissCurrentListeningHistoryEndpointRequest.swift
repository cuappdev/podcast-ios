//
//  DismissCurrentListeningHistoryEndpointRequest.swift
//  Podcast
//
//  Created by Natasha Armbrust on 4/22/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import Foundation

import SwiftyJSON

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
