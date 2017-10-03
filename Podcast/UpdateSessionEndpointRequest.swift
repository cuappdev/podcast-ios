
import UIKit
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
