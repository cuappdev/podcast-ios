//
//  DiscoverEndpointRequests.swift
//  Podcast
//
//  Created by Jack Thompson on 8/27/18.
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
    
    init(requestType: DiscoverEndpointType, topicID: Int, offset: Int = 0, max: Int = 10) {
        self.requestType = requestType
        super.init()
        path = "/discover/\(requestType.rawValue)/topic/\(topicID)/"
        httpMethod = .get
        queryParameters = ["offset": offset, "max": max]
    }
    
    override func processResponseJSON(_ json: JSON) {
        switch requestType {
        case .episodes:
            processedResponseValue = json["data"][requestType.rawValue].map{ episodeJSON in
                Cache.sharedInstance.update(episodeJson: episodeJSON.1)
            }
        case .series:
            processedResponseValue = json["data"][requestType.rawValue].map{ seriesJSON in
                Cache.sharedInstance.update(seriesJson: seriesJSON.1)
            }
        }
    }
    
}

class DiscoverUserEndpointRequest: EndpointRequest {
    
    var requestType: DiscoverEndpointType
    
    init(requestType: DiscoverEndpointType, offset: Int = 0, max: Int = 0) {
        self.requestType = requestType
        super.init()
        path = "/discover/\(requestType.rawValue)/user/"
        httpMethod = .get
        queryParameters = ["offset": offset, "max": max]
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

class GetAllTopicsEndpointRequest: EndpointRequest {
    
    override init() {
        super.init()
        path = "/topics/parent/"
        httpMethod = .get
    }
    
    override func processResponseJSON(_ json: JSON) {
        processedResponseValue = json["data"]["topics"].map{ topicsJSON in Topic(json: topicsJSON.1) }
    }
    
}
