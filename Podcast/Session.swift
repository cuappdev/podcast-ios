//
//  Session.swift
//  Podcast
//
//  Created by Natasha Armbrust on 3/1/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class Session: NSObject {
    
    var sessionToken: String
    var expiresAt: Date
    
    init(sessionToken: String, expiresAt: Date) {
        self.sessionToken = sessionToken
        self.expiresAt = expiresAt
    }
}
