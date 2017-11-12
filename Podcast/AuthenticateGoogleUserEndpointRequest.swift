
import UIKit
import SwiftyJSON

class AuthenticateGoogleUserEndpointRequest: EndpointRequest {
    
    var accessToken: String
    
    init(accessToken: String) {
        
        self.accessToken = accessToken
        
        super.init()
        
        path = "/users/google_sign_in/"
        
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
