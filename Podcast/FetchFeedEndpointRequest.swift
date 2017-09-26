//
//  FetchFeedEndpointRequest.swift
//  Podcast
//
//  Created by Natasha Armbrust on 5/4/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import SwiftyJSON

class FetchFeedEndpointRequest: EndpointRequest {
    
    var offset: Int
    var max: Int
    
    init(offset: Int, max: Int) {
        
        self.max = max
        self.offset = offset
        
        super.init()
        
        path = "/feed/"
        httpMethod = .get
        queryParameters = ["max": max, "offset": offset]
    }
    
    override func processResponseJSON(_ json: JSON) {
        var cards: [Card] = []
        for element in json["data"]["feeds"] {
            let cardJson = element.1
            let feedType = cardJson["feedType"].stringValue
            switch (feedType) {
            case "recommendationFeedElement":
                let recommendedCard = RecommendedCard(json: cardJson)
                cards.append(recommendedCard)
            default:
                break
            }
        }
        processedResponseValue = cards 
    }
}
