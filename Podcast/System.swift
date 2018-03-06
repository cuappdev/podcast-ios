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

    static var keys: Keys = Keys()
    
    static func isiPhoneX() -> Bool {
        return UIScreen.main.nativeBounds.height == 2436
    }
}

/* hidden Keys.plist for sensitive information */
class Keys: NSObject {

    var keyDict: NSDictionary

    var apiURL: String {
        get {
            return self.keyDict["api-url"] as? String ?? ""
        }
    }
    
    var privacyPolicyURL: String {
        get {
            return self.keyDict["privacypolicy-url"] as? String ?? ""
        }
    }


    override init() {
        keyDict = [:]
        if let path = Bundle.main.path(forResource: "Keys", ofType: "plist"), let dict = NSDictionary(contentsOfFile: path) {
            keyDict = dict
        }
        super.init()
    }
}
