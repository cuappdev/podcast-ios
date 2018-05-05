//
//  DownloadManager.swift
//  Podcast
//
//  Created by Drew Dunne on 2/17/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit
import Alamofire

protocol EpisodeDownloader {
    func didReceiveDownloadUpdateFor(episode: Episode)
}

class DownloadManager: NSObject {
    
    static let shared = DownloadManager()
    
    private var filePath: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        return (url!.appendingPathComponent("SaveData").path)
    }
    
    var downloaded: [String: Episode]
    
    private override init() {
        downloaded = [:]
    }
    
    func downloadOrRemove(episode: Episode, callback: @escaping (Episode) -> ()) {
        if !episode.isDownloaded {
            if let url = episode.audioURL {
                let destination: DownloadRequest.DownloadFileDestination = { _, _ in
                    // This can't fail if audioURL is defined
                    return (episode.fileURL!, [.removePreviousFile, .createIntermediateDirectories])
                }
                let request: DownloadRequest
                if let data = episode.resumeData {
                    request = Alamofire.download(resumingWith: data, to: destination)
                    episode.percentDownloaded = 0
                    callback(episode)
                } else {
                    request = Alamofire.download(url, to: destination)
                    episode.percentDownloaded = 0
                    callback(episode)
                }
                request
                    // Leave until we can do progress updating
                    .downloadProgress { progress in
                        // For now just call the callback
                        episode.percentDownloaded = progress.fractionCompleted
                    }
                    .responseData { response in
                        switch response.result {
                        case .success(_):
                            episode.resumeData = nil
                            episode.isDownloaded = true
                            episode.percentDownloaded = nil
                            _ = self.registerDownload(episode: episode)
                            callback(episode)
                        case .failure:
                            episode.resumeData = response.resumeData
                            episode.isDownloaded = false
                            episode.percentDownloaded = nil
                            callback(episode)
                        }
                }
            }
        } else {
            do {
                if let url = episode.fileURL {
                    let fileManager = FileManager.default
                    try fileManager.removeItem(atPath: url.path)
                    episode.isDownloaded = false
                    _ = removeDownload(episode: episode)
                    callback(episode)
                }
            }
            catch let error as NSError {
                // Couldn't remove (probably not there), so remove from downloaded state
                episode.isDownloaded = false
                _ = removeDownload(episode: episode)
                callback(episode)
                print("Couldn't delete the file because of: \(error)")
            }
        }
    }
    
    // Returns if successfully registered
    private func registerDownload(episode: Episode) -> Bool {
        downloaded[episode.id] = episode
        return saveAllData()
    }
    
    // Returns if successfully removed
    private func removeDownload(episode: Episode) -> Bool {
        downloaded.removeValue(forKey: episode.id)
        return saveAllData()
    }
    
    // Returns true if successful
    func saveAllData() -> Bool {
        return NSKeyedArchiver.archiveRootObject(downloaded, toFile: filePath)
    }
    
    // Returns true if successful
    func loadAllData() -> Bool {
        if let data = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [String: Episode] {
            downloaded = data
            // Update list with Cache items if exist
            // otherwise add to Cache
            downloaded.forEach { (id, episode) in
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
