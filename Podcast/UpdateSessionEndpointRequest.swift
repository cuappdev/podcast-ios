
import UIKit
import SwiftyJSON

class UpdateSessionEndpointRequest: EndpointRequest {
    
    var updateToken: String
    
    init(updateToken: String) {
        
        self.updateToken = updateToken
        
        super.init()
        
        path = "/sessions/update/"
        
        requiresAuthenticatedUser = false
        
        httpMethod = .post
        
        headers = ["UpdateToken": updateToken]
    }
    
    override func processResponseJSON(_ json: JSON) {
        
        let userJSON = json["data"]["user"]
        let user = User(json: userJSON)
        
        let sessionJSON = json["data"]["user"]["session"]
        let session = Session(json: sessionJSON)
        
        processedResponseValue = ["user": user, "session": session]
    }
}
