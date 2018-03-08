//
//  MergeUserAccountsEndpointRequest.swift
//  Podcast
//
//  Created by Natasha Armbrust on 12/15/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import SwiftyJSON

class MergeUserAccountsEndpointRequest: EndpointRequest {

    var accessToken: String
    var signInType: SignInType

    init(signInType: SignInType, accessToken: String) {
        self.accessToken = accessToken
        self.signInType = signInType
        super.init()

        path = "/users/merge/"
        queryParameters = ["platform": String(describing: signInType).lowercased()]
        if signInType == .Facebook, let facebookAccessToken = Authentication.sharedInstance.facebookAccessToken {
            headers = ["AccessToken": facebookAccessToken]
        }

        httpMethod = .post
    }

    override func processResponseJSON(_ json: JSON) {
        processedResponseValue = User(json: json["data"]["user"])
    }
}
