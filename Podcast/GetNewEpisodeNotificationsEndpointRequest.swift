//
//  GetNewEpisodeNotificationsEndpointRequest.swift
//  Podcast
//
//  Created by Mindy Lou on 5/7/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import Foundation
import SwiftyJSON

/// Endpoint request to retrieve new episode notifications.
/// Should be made once upon opening the app and subsequent reloads of the notifications tab.
class GetNewEpisodeNotificationsEndpointRequest: EndpointRequest {

    init(offset: Int = 0, max: Int = 20) {
        super.init()
        path = "/notifications/episodes/"
        httpMethod = .get
        queryParameters = ["offset": offset, "max": max]
    }

    override func processResponseJSON(_ json: JSON) {
        processedResponseValue = json["data"]["episodes"].map { episodeJSON in
            Cache.sharedInstance.update(episodeJson: episodeJSON.1 )
        }
    }
}
