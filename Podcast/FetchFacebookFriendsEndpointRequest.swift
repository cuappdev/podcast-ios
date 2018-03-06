//
//  FetchFacebookFriendsEndpointRequest.swift
//  Podcast
//
//  Created by Natasha Armbrust on 12/17/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import SwiftyJSON

class FetchFacebookFriendsEndpointRequest: EndpointRequest {

    var pageSize: Int
    var offset: Int

    init(facebookAccessToken: String, pageSize: Int, offset: Int) {

        self.offset = offset
        self.pageSize = pageSize

        super.init()

        path = "/users/facebook/friends/"
        httpMethod = .get
        queryParameters = ["offset": offset, "max": pageSize]
        headers = ["AccessToken": facebookAccessToken]
    }

    override func processResponseJSON(_ json: JSON) {
        processedResponseValue = json["data"]["users"].map{ element in User(json: element.1) }
    }
}
