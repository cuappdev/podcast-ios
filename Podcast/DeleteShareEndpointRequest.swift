//
//  DeleteShareEndpointRequest.swift
//  Podcast
//
//  Created by Natasha Armbrust on 3/4/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import Foundation
import SwiftyJSON

class DeleteShareEndpointRequest: EndpointRequest {

    var shareId: String

    init(shareId: String) {
        self.shareId = shareId
        super.init()

        httpMethod = .delete
        path = "/shares/\(shareId)/"
    }
}

