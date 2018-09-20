//
//  Endpoints.swift
//  Recast
//
//  Created by Drew Dunne on 9/19/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import Foundation
import Draft

struct SearchEndpoint: DecodableDraft {
    
    typealias ResponseType = SearchResults
    
    let host = "itunes.apple.com"
    let route = "/search"
    let parameters: HTTPParameters
    
    var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy? {
        return .iso8601
    }
    
}
