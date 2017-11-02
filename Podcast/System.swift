//
//  System.swift
//  Podcast
//
//  Created by Natasha Armbrust on 3/2/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class System: NSObject {
    
    static let feedTab = 0
    static let discoverTab: Int = 1
    static let searchTab: Int = 2
    static let bookmarkTab: Int = 3
    static let profileTab: Int = 4
    
    static var currentUser: User?

    static var currentSession: Session?
    
    static var endpointRequestQueue = EndpointRequestQueue()
    
}
