//
//  System.swift
//  Podcast
//
//  Created by Natasha Armbrust on 3/2/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class System {
    // TODO: CHANGE THIS
    static let feedTab = 0
    static let discoverSearchTab: Int = 1
    static let bookmarkTab: Int = 2
    static let profileTab: Int = 3
    
    static var currentUser: User?

    static var currentSession: Session?
    
    static var endpointRequestQueue = EndpointRequestQueue()
    
    static func isiPhoneX() -> Bool {
        return UIScreen.main.nativeBounds.height == 2436
    }
}
