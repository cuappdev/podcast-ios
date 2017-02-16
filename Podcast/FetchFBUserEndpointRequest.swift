
import UIKit
import SwiftyJSON

class FetchFBUserEndpointRequest: EndpointRequest {
    
    var token: String
    
    init(token: String) {
        
        self.token = token
        
        super.init()
        
        path = "/users/fb_auth"
        
        httpMethod = .post
        
        headers = ["FB_TOKEN" : token]
    }
    
    override func proccessResponseJSON(_ json: JSON) {
        
        proccessedResponseValue = json["data"]
        
    }
}
