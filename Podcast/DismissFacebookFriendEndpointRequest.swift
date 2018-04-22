//
//  DismissFacebookFriendEndpointRequest.swift
//  Podcast
//
//  Created by Natasha Armbrust on 4/10/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import Foundation
import SwiftyJSON

class DismissFacebookFriendEndpointRequest: EndpointRequest {

    var facebookId: String // id of the friend we are dismissing

    init(facebookAccessToken: String, facebookId: String) {
        self.facebookId = facebookId

        super.init()

        path = "/users/facebook/friends/ignore/\(facebookId)/"
        httpMethod = .post
        headers = ["AccessToken": facebookAccessToken]
    }
}
