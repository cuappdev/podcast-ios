//
//  FetchListeningHistoryEndpointRequest.swift
//  Podcast
//
//  Created by Kevin Greer on 5/7/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import Foundation
import SwiftyJSON

class FetchListeningHistoryEndpointRequest: EndpointRequest {
    
    var offset: Int
    var max: Int

    //dismissed is an optional argument that if supplied will filter the
    // listening history such that all returned listening history entries have their dismissed value equal to the supplied value.
    var dismissed: Bool?
    
    init(offset: Int, max: Int, dismissed: Bool? = nil) {
        self.offset = offset
        self.max = max
        self.dismissed = dismissed

        super.init()
        path = "/history/listening/"
        httpMethod = .get
        queryParameters = ["offset": offset, "max": max]
        if let dismiss = dismissed {
             queryParameters!["dismissed"] = encodeBoolean(dismiss)
        }
    }
    
    override func processResponseJSON(_ json: JSON) {
        processedResponseValue = json["data"]["listening_histories"].map{ episodeJosn in
            Cache.sharedInstance.update(episodeJson: episodeJosn.1["episode"])
        }
    }
}
