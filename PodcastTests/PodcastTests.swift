//
//  PodcastTests.swift
//  PodcastTests
//
//  Created by Mark Bryan on 9/7/16.
//  Copyright © 2016 Cornell App Development. All rights reserved.
//

import XCTest
@testable import Podcast

class PodcastTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testKeys() {
        XCTAssert(Keys.apiURL.value != "", "api url missing")
        XCTAssert(Keys.facebookAppID.value != "", "facebook app id missing")
        XCTAssert(Keys.fabricAPIKey.value != "", "fabric api key missing")
        XCTAssert(Keys.fabricBuildSecret.value != "", "fabric build secret missing")
    }
    
}
