//
//  SaveReadNotificationsEndpointRequest.swift
//  Podcast
//
//  Created by Mindy Lou on 5/7/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import Foundation
import SwiftyJSON

/// Endpoint request to save which notifications have been read via episode ids.
/// Should be made upon exiting the app.
class SaveReadNotificationsEndpointRequest: EndpointRequest {

    init(readIds: [String: String]) {
        super.init()
        httpMethod = .put
        path = "/notifications/read/"
        bodyParameters = readIds // TODO: determine if this info is correct
    }

    override func processResponseJSON(_ json: JSON) {
        print(json)
    }
}
