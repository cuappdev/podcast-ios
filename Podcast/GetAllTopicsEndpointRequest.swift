//
//  GetAllTopicsEndpointRequest.swift
//  Podcast
//
//  Created by Mindy Lou on 2/9/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//
import SwiftyJSON

class GetAllTopicsEndpointRequest: EndpointRequest {

    override init() {
        super.init()
        path = "/topics/parent/"
        httpMethod = .get
        requiresAuthenticatedUser = true
    }

    override func processResponseJSON(_ json: JSON) {
        processedResponseValue = json["data"]["topics"].map{ topicsJSON in Topic(json: topicsJSON.1) }
    }

}
