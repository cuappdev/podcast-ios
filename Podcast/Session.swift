//
//  Session.swift
//  Podcast
//
//  Created by Natasha Armbrust on 3/1/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import SwiftyJSON

class Session {
    
    var sessionToken: String
    var updateToken: String
    var expiresAt: Date
    
    init(sessionToken: String, updateToken: String, expiresAt: Date) {
        self.sessionToken = sessionToken
        self.updateToken = updateToken
        self.expiresAt = expiresAt
    }
    
    convenience init(json: JSON) {
        
        let sessionToken = json["sessionToken"].stringValue
        let updateToken = json["updateToken"].stringValue
        let expiresAt = Date(timeIntervalSince1970: json["expiresAt"].doubleValue)
        
        self.init(sessionToken: sessionToken, updateToken: updateToken, expiresAt: expiresAt)
    }
}
