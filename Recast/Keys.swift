//
//  Keys.swift
//  Recast
//
//  Created by Jack Thompson on 10/10/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import Foundation

/* hidden Keys.plist for sensitive information */
enum Keys: String {
    case fabricAPIKey = "fabric-api-key"
    case fabricBuildSecret = "fabric-build-secret"

    var value: String {
        return Keys.keyDict[rawValue] as? String ?? ""
    }

    private static let keyDict: NSDictionary = {
        guard let path = Bundle.main.path(forResource: "Keys", ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path) else { return [:] }
        return dict
    }()
}
