//
//  OptInNotificationsForSeriesEndpointRequest.swift
//  Podcast
//
//  Created by Mindy Lou on 5/2/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import Foundation
import SwiftyJSON

class OptInNotificationsForSeriesEndpointRequest: EndpointRequest {
    var seriesID: String

    init(seriesID: String) {
        self.seriesID = seriesID
        super.init()
        httpMethod = .post
        path = "/notifications/episodes/\(seriesID)/"
    }

    override func processResponseJSON(_ json: JSON) {
        print(json)
    }
    
}

