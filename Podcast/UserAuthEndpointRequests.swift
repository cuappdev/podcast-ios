//
//  UserAuthEndpointRequests.swift
//  Podcast
//
//  Created by Jack Thompson on 8/27/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import Foundation
import SwiftyJSON

class UpdateSessionEndpointRequest: EndpointRequest {
    
    var updateToken: String
    
    init(updateToken: String) {
        
        self.updateToken = updateToken
        
        super.init()
        
        path = "/sessions/update/"
        
        requiresAuthenticatedUser = true
        
        httpMethod = .post
        
        queryParameters = ["update_token": updateToken]
    }
    
    override func processResponseJSON(_ json: JSON) {
        
        let userJSON = json["data"]["user"]
        let user = User(json: userJSON)
        
        let sessionJSON = json["data"]["session"]
        let session = Session(json: sessionJSON)
        
        processedResponseValue = ["user": user, "session": session]
    }
}

enum SignInType {
    case Facebook
    case Google
    
    var url: String {
        switch self {
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
        
        path = signInType.url
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
        } else if let googleAccessToken = Authentication.sharedInstance.googleAccessToken {
            headers = ["AccessToken": googleAccessToken]
        }
        
        httpMethod = .post
    }
    
    override func processResponseJSON(_ json: JSON) {
        processedResponseValue = User(json: json["data"]["user"])
    }
}
