//
//  BookmarksEndpointRequest.swift
//  Podcast
//
//  Created by Jack Thompson on 8/27/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

class FetchBookmarksEndpointRequest: EndpointRequest {
    
    override init() {
        super.init()
        
        path = "/bookmarks/"
        httpMethod = .get
    }
    
    override func processResponseJSON(_ json: JSON) {
        processedResponseValue = json["data"]["bookmarks"].map{ bookmarkJson in
            Cache.sharedInstance.update(episodeJson: bookmarkJson.1["episode"])
        }
    }
}

class ModifyBookmarkEndpointRequest: EndpointRequest {
    var episodeID: String
    
    init(episodeID: String, method: HTTPMethod) {
        self.episodeID = episodeID
        super.init()
        
        path = "/bookmarks/\(episodeID)/"
        httpMethod = method
    }
}
