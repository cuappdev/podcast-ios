//
//  SearchFacebookFriendsEndpointRequest.swift
//  Podcast
//
//  Created by Natasha Armbrust on 2/16/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import Foundation
import SwiftyJSON

class SearchFacebookFriendsEndpointRequest: EndpointRequest {

    var offset: Int
    var max: Int
    var query: String

    init(facebookAccessToken: String, query: String, offset: Int, max: Int) {
        self.query = query
        self.offset = offset
        self.max = max

        super.init()

        path = "/search/facebook/friends/\(query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? query)/"
        httpMethod = .get
        queryParameters = ["offset": offset, "max": max]
        headers = ["access_token": facebookAccessToken]

        
    }

    override func processResponseJSON(_ json: JSON) {
        processedResponseValue = json["data"]["users"].map{ element in User(json: element.1) }
    }
}
