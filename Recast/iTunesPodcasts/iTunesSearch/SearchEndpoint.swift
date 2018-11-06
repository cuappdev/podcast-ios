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
        guard let count = countJson.int, count > 0, let resultsArr = resultsJson.array else {
            return SearchResults(resultCount: 0, results: [])
        }
        let results = resultsArr.map { resultJson in SearchResult(json: resultJson) }
        return SearchResults(resultCount: count, results: results)
    }

}
