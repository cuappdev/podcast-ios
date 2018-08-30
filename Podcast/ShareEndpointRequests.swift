//
//  ShareEndpointRequest.swift
//  Podcast
//
//  Created by Jack Thompson on 8/26/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import Foundation
import SwiftyJSON

class FetchSharesEndpointRequest: EndpointRequest {
    
    var offset: Int
    var max: Int
    
    init(offset: Int, max: Int) {
        self.offset = offset
        self.max = max
        super.init()
        
        httpMethod = .get
        path = "/shares/"
        queryParameters = ["offset": offset, "max": max]
    }
    
    override func processResponseJSON(_ json: JSON) {
        processedResponseValue = json["data"]["shares"].map{ element in
            createFeedElement(json: element.1)
        }
    }
    
    // TODO: this is hacky sorry it will be changed
    // necessary because backend doesn't give us Feed elements but for rn we are using feed cells
    func createFeedElement(json: JSON) -> FeedElement? {
        let feedElement = FeedElement(json: createFeedJson(json: json))
        feedElement?.time = DateFormatter.restAPIDateFormatter.date(from: json["updated_at"].stringValue) ?? Date()
        return feedElement
    }
    
    func createFeedJson(json: JSON) -> JSON {
        var feedJSON = JSON()
        feedJSON["context"] = "SHARED_EPISODE"
        feedJSON["content"] = json["episode"]
        feedJSON["context_supplier"] = json["sharer"]
        feedJSON["time"] = 0.0 // arbitrary
        feedJSON["id"] = json["id"]
        return feedJSON
    }
}

class CreateShareEndpointRequest: EndpointRequest {
    
    var userSharedWithIds: [String]
    var episodeId: String
    
    init(episodeId: String, userSharedWithIds: [String]) {
        self.episodeId = episodeId
        self.userSharedWithIds = userSharedWithIds
        super.init()
        
        httpMethod = .post
        path = "/shares/\(episodeId)/"
        var shareString = ""
        for (i,id) in userSharedWithIds.enumerated() {
            shareString += i > 0 ? ("," + id) : id
        }
        queryParameters = ["sharee_ids": shareString]
    }
}

class DeleteShareEndpointRequest: EndpointRequest {
    
    var shareId: String
    
    init(shareId: String) {
        self.shareId = shareId
        super.init()
        
        httpMethod = .delete
        path = "/shares/\(shareId)/"
    }
}
