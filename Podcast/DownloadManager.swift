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
    
    private var filePath: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        return (url!.appendingPathComponent("SaveData").path)
    }
    
    var downloaded: Dictionary<String, Episode>
    
    private override init() {
        downloaded = Dictionary<String, Episode>()
    }
    
    // Returns if successfully registered
    func registerDownload(episode: Episode) -> Bool {
        downloaded[episode.id] = episode
        return saveAllData()
    }
    
    // Returns if successfully removed
    func removeDownload(episode: Episode) -> Bool {
        downloaded.removeValue(forKey: episode.id)
        return saveAllData()
    }
    
    // Returns true if successful
    func saveAllData() -> Bool {
        return NSKeyedArchiver.archiveRootObject(self.downloaded, toFile: filePath)
    }
    
    // Returns true if successful
    func loadAllData() -> Bool {
        if let data = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? Dictionary<String, Episode> {
            downloaded = data
            // Update list with Cache items if exist
            // otherwise add to Cache
            downloaded.forEach { (arg) in
                let (id, episode) = arg
                if let e = Cache.sharedInstance.get(episode: id) {
                    downloaded[id] = e
                } else {
                    Cache.sharedInstance.add(episode: episode)
                }
            }
            return true
        }
        return false
    }
    
}
