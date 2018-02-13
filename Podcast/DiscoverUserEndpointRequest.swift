//
//  DiscoverUserEndpointRequest.swift
//  Podcast
//
//  Created by Mindy Lou on 2/1/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import Foundation
import SwiftyJSON

class DiscoverUserEndpointRequest: EndpointRequest {

    var requestType: DiscoverEndpointType

    init(requestType: DiscoverEndpointType) {
        self.requestType = requestType
        super.init()
        path = "/discover/\(requestType.rawValue)/user/"
        httpMethod = .get
    }

    override func processResponseJSON(_ json: JSON) {
        switch requestType {
        case .episodes:
            processedResponseValue = json["data"][requestType.rawValue].map{ episodesJSON in
                Cache.sharedInstance.update(episodeJson: episodesJSON.1)
            }
        case .series:
            processedResponseValue = json["data"][requestType.rawValue].map{ seriesJSON in
                Cache.sharedInstance.update(seriesJson: seriesJSON.1)
            }
        }
    }

}
