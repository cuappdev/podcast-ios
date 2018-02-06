//
//  DiscoverTopicEndpointRequest.swift
//  Podcast
//
//  Created by Mindy Lou on 1/31/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import Foundation
import SwiftyJSON

enum DiscoverEndpointType: String {
    case episodes = "episodes"
    case series = "series"
}

class DiscoverTopicEndpointRequest: EndpointRequest {

    var requestType: DiscoverEndpointType

    init(requestType: DiscoverEndpointType, topicID: String) {
        self.requestType = requestType
        super.init()
        path = "/discover/\(requestType.rawValue)/topic/\(topicID)/"
        httpMethod = .get
    }

    override func processResponseJSON(_ json: JSON) {
        switch requestType {
        case .episodes:
            processedResponseValue = json["data"][requestType.rawValue].map{ seriesJSON in Episode(json: seriesJSON.1) }
        case .series:
            processedResponseValue = json["data"][requestType.rawValue].map{ seriesJSON in Series(json: seriesJSON.1) }
        }
    }

}
