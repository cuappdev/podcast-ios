//
//  DeleteBookmarkEndpointRequest.swift
//  Podcast
//
//  Created by Kevin Greer on 4/29/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import Foundation
import SwiftyJSON

class DeleteBookmarkEndpointRequest: EndpointRequest {
    
    var episodeID: String
    
    init(episodeID: String) {
        self.episodeID = episodeID
        super.init()
        path = "/bookmarks/\(episodeID)"
        httpMethod = .delete
    }
}
