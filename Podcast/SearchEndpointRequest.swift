
import UIKit
import SwiftyJSON

class SearchEndpointRequest: EndpointRequest {
    
    var query: String
    
    init(query: String) {
        
        self.query = query
        
        super.init()
        
        path = "/search"
        
        httpMethod = .get
        
        queryParameters = ["query":query]
        
        headers = [HeaderFields.SessionToken : User.currentUser.sessionToken]
    }
    
    override func proccessResponseJSON(_ json: JSON) {
        
        let responseData = json["data"]
        let episodesJSON = responseData["episodes"].arrayValue
        let results = episodesJSON.map({ (episodeJSON: JSON) in
            Episode(id: 0,
                    title: episodeJSON["title"].stringValue,
                    dateCreated: Date(),
                    descriptionText: episodeJSON["description"].stringValue,
                    smallArtworkImage: #imageLiteral(resourceName: "fillerImage"),
                    largeArtworkImage: #imageLiteral(resourceName: "fillerImage"),
                    mp3URL: episodeJSON["audio_url"].stringValue)
        })
        
        proccessedResponseValue = results
    }
    
}
