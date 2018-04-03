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
    // returnFollowing: If true, return your friends sorted by the number of followers.
    // If false, only return your friends that you are not following also sorted by the number of followers
    var returnFollowing: Bool?

    init(facebookAccessToken: String, pageSize: Int, offset: Int, returnFollowing: Bool?) {

        self.offset = offset
        self.pageSize = pageSize
        self.returnFollowing = returnFollowing

        super.init()

        path = "/users/facebook/friends/"
        httpMethod = .get
        queryParameters = ["offset": offset, "max": pageSize]
        if let following = returnFollowing {
            queryParameters!["return_following"] = following
        }
        headers = ["AccessToken": facebookAccessToken]
    }

    override func processResponseJSON(_ json: JSON) {
        processedResponseValue = json["data"]["users"].map{ element in User(json: element.1) }
    }
}
