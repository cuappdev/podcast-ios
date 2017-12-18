//
//  MergeUserAccountsEndpointRequest.swift
//  Podcast
//
//  Created by Natasha Armbrust on 12/15/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import SwiftyJSON

class MergeUserAccuntsEndpointRequest: EndpointRequest {

    var accessToken: String
    var signInType: SignInType

    init(signInType: SignInType, accessToken: String) {
        self.accessToken = accessToken
        self.signInType = signInType
        super.init()

        path = "/users/merge/"
        queryParameters = ["access_token": accessToken, "platform": String(describing: signInType).lowercased()]
        httpMethod = .post
    }

    override func processResponseJSON(_ json: JSON) {
        let userJSON = json["data"]["user"]
        let user = User(json: userJSON)
        let isNewUser = json["data"]["is_new_user"].boolValue

        let sessionJSON = json["data"]["session"]
        let session = Session(json: sessionJSON)

        processedResponseValue = ["user": user, "session": session, "is_new_user": isNewUser]
    }
}
