//
//  DownloadManager.swift
//  Podcast
//
//  Created by Drew Dunne on 2/17/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit
import Alamofire

class DownloadManager: NSObject {
    
    static let shared = DownloadManager()
    
    var downloaded: Dictionary<String, OfflineEpisode>
    
    private override init() {
        downloaded = Dictionary<String, OfflineEpisode>()
    }
    
    // Returns if successfully registered
    func registerDownload(episode: Episode) -> Bool {
        
        return false
    }
    
}
