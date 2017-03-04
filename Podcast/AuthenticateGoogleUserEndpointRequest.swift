
import UIKit
import SwiftyJSON

class AuthenticateGoogleUserEndpointRequest: EndpointRequest {
    
    var idToken: String
    
    init(idToken: String) {
        
        self.idToken = idToken
        
        super.init()
        
        path = "/users/google_auth"
        
        httpMethod = .post
        
        queryParameters = ["id_token": idToken]
        
    }
    
    override func processResponseJSON(_ json: JSON) {
        
        processedResponseValue = json["data"]
        
    }
}
