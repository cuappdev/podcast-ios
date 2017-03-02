
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
        
        headers = ["SESSION_TOKEN" : (CurrentUser.currentUser.session?.sessionToken)!]
    }
    
    override func processResponseJSON(_ json: JSON) {
    
        let responseData = json["data"]
        let episodesJSON = responseData["episodes"].arrayValue
        let results = episodesJSON.map({ (episodeJSON: JSON) in
            //replace with new episode init
            /*Episode(id: 0,
                    title: episodeJSON["title"].stringValue,
                    dateCreated: Date(),
                    descriptionText: episodeJSON["description"].stringValue,
                    smallArtworkImageURL: UIImage(named: "filler_image")!,
                    largeArtworkImageURL: UIImage(named: "filler_image")!,
                    mp3URL: episodeJSON["audio_url"].stringValue)
            */
        })
        
        processedResponseValue = results
    }
    
}
