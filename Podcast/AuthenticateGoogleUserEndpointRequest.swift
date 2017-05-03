
import UIKit
import SwiftyJSON

class AuthenticateGoogleUserEndpointRequest: EndpointRequest {
    
    var idToken: String
    
    init(idToken: String) {
        
        self.idToken = idToken
        
        super.init()
        
        path = "/users/google_sign_in"
        
        requiresAuthenticatedUser = false
        
        httpMethod = .post
        
        queryParameters = ["id_token": idToken]
    }
    
    override func processResponseJSON(_ json: JSON) {
        
        let userJSON = json["data"]["user"]
        let user = User(json: userJSON)
        let isNewUser = json["data"]["newUser"].boolValue
        
        let sessionJSON = json["data"]["user"]["session"]
        let session = Session(json: sessionJSON)
        
        processedResponseValue = ["user": user, "session": session, "newUser": isNewUser]
    }
}
