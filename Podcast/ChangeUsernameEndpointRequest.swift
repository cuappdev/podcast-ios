
import UIKit
import SwiftyJSON

class ChangeUsernameEndpointRequest: EndpointRequest {
    
    var username: String
    
    init(username: String) {
        
        self.username = username
        super.init()
        
        path = "/users/change_username/"
        httpMethod = .post
        queryParameters = ["username": username]
        requiresAuthenticatedUser = true
    }
    
    override func processResponseJSON(_ json: JSON) {
        //don't really need these b/c same user,session returned
        let userJSON = json["data"]["user"]
        let user = Cache.sharedInstance.update(userJson: userJSON)
        let sessionJSON = json["data"]["user"]["session"]
        let session = Session(json: sessionJSON)
        processedResponseValue = ["user": user, "session": session]
    }
}
