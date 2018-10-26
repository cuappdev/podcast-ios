//
//  Endpoints.swift
//  Recast
//
//  Created by Drew Dunne on 9/19/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import Foundation
import Draft

struct SearchEndpoint: JSONDraft {

    typealias ResponseType = SearchResults

    let host = "itunes.apple.com"
    let route = "/search"
    let parameters: HTTPParameters

    var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy? {
        return .iso8601
    }

    func convert(json: JSON) throws -> ResponseType {
        let countJson = json["resultCount"]
        let resultsJson = json["results"]
        //swiftlint:disable:next empty_count
        if let count = countJson.int, count > 0, let resultsArr = resultsJson.array {
            let results = resultsArr.map { _ in SearchResult(json: resultsJson) }
            return SearchResults(resultCount: count, results: results)
        }
        return SearchResults(resultCount: 0, results: [])
    }

}
