//
//  System.swift
//  Podcast
//
//  Created by Natasha Armbrust on 3/2/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class System: NSObject {
    
    static var currentUser: User?

    static var currentSession: Session?
    
    static var endpointRequestQueue = EndpointRequestQueue()
    
}
