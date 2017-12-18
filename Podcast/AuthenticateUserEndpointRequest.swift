//
//  AuthenticateUserEndpointRequest.swift
//  Podcast
//
//  Created by Natasha Armbrust on 12/13/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import SwiftyJSON

enum SignInType {
    case Facebook
    case Google

    var signInURL: String {
        switch(self) {
        case .Facebook:
            return "/users/facebook_sign_in/"
        case .Google:
            return "/users/google_sign_in/"
        }
    }
}

class AuthenticateUserEndpointRequest: EndpointRequest {

    var accessToken: String
    var signInType: SignInType

    init(signInType: SignInType, accessToken: String) {
        self.accessToken = accessToken
        self.signInType = signInType
        super.init()

        path = signInType.signInURL
        requiresAuthenticatedUser = false
        httpMethod = .post
        bodyParameters = ["access_token": accessToken]
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
