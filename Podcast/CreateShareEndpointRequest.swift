//
//  CreateShareEndpointRequest.swift
//  Podcast
//
//  Created by Natasha Armbrust on 3/4/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import Foundation
import SwiftyJSON

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
