
import UIKit
import SwiftyJSON

class AuthenticateGoogleUserEndpointRequest: EndpointRequest {
    
    var idToken: String
    
    init(idToken: String) {
        
        self.idToken = idToken
        
        super.init()
        
        path = "/users/google_sign_in"
        
        httpMethod = .post
        
        queryParameters = ["id_token": idToken]
        
        print(idToken)
        
    }
    
    override func processResponseJSON(_ json: JSON) {
        
        let userJSON = json["data"]["user"]
        let user = User(json: userJSON)
        processedResponseValue = user
        
    }
}
