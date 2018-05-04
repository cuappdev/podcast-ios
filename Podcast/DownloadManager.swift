//
//  DownloadManager.swift
//  Podcast
//
//  Created by Drew Dunne on 2/17/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit
import Alamofire

enum DownloadStatus {
    case waiting
    case downloading(Double)
    case finished
    case failed
    case removed
    case cancelled
}

// To receive updates set yourself as delegate. Only one can receive at a time.
protocol EpisodeDownloader: class {
    func didReceive(statusUpdate: DownloadStatus, for episode: Episode)
}

class DownloadManager: NSObject {
    
    static let shared = DownloadManager()
    
    private var filePath: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        return (url!.appendingPathComponent("SaveData").path)
    }
    
    var downloaded: [String: Episode]
    var downloadRequests: [String: DownloadRequest]
    var resumeData: [String: Data]
    
    // QUESTION: delegate or NSNotification or custom KVO?
    // Hopefully only temporary, we'll see what realm does.
    // This kind of an abuse of delegates but honestly it's
    // kind of nice. Basically any view that wants updates
    // sets itself as the delegate on viewDidAppear.
    // Doesn't have to worry about removing itself because
    // it's a weak reference, and only one view at a time
    // gets updates.
    weak var delegate: EpisodeDownloader?
    
    private override init() {
        downloaded = [:]
        downloadRequests = [:]
        resumeData = [:]
        super.init()
        if !saveAllData() {
            print("Error loading download data.")
        }
    }
    
    // Cannot return download progress
    func status(for episode: String) -> DownloadStatus {
        if isDownloading(episode) {
            return .waiting
        } else if isDownloaded(episode) {
            return .finished
        } else {
            return .removed
        }
    }
    
    func isDownloaded(_ episode: String) -> Bool {
        return downloaded.contains(where: { (k, v) in k == episode})
    }
    
    func isDownloading(_ episode: String) -> Bool {
        return downloadRequests.contains(where: { (k, v) in k == episode})
    }
    
    func actionSheetType(for episode: String) -> ActionSheetOptionType {
        if isDownloaded(episode) {
            return .download(selected: true)
        } else if isDownloading(episode) {
            return .cancelDownload
        } else {
            return .download(selected: false)
        }
    }
    
    func fileUrl(for episode: Episode) -> URL {
        if let url = episode.audioURL {
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let pathURL = documentsURL.appendingPathComponent("downloaded").appendingPathComponent("\(episode.id)_\(episode.seriesTitle)")
            return pathURL.appendingPathComponent(episode.id + "_" + url.lastPathComponent)
        } else {
            // This path should never be used
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let pathURL = documentsURL.appendingPathComponent("downloaded").appendingPathComponent("\(episode.id)_\(episode.seriesTitle)")
            return pathURL.appendingPathComponent(episode.id)
        }
    }
    
    // Requires: episode is not downloaded or paused
    func download(_ episode: Episode) {
        guard let audioUrl = episode.audioURL else { return }
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            // This can't fail if audioURL is defined
            return (self.fileUrl(for: episode), [.removePreviousFile, .createIntermediateDirectories])
        }
        let request: DownloadRequest
        if let data = resumeData[episode.id] {
            request = Alamofire.download(resumingWith: data, to: destination)
        } else {
            request = Alamofire.download(audioUrl, to: destination)
        }
        downloadRequests[episode.id] = request
        delegate?.didReceive(statusUpdate: .waiting, for: episode)
        request
            // Leave comment
//            .downloadProgress { progress in
//                self.delegate?.didReceive(statusUpdate: .downloading(progress.fractionCompleted), for: episode)
//            }
            .responseData { response in
                switch response.result {
                case .success(_):
                    self.registerDownload(for: episode)
                    self.delegate?.didReceive(statusUpdate: .finished, for: episode)
                case .failure:
                    self.delegate?.didReceive(statusUpdate: .failed, for: episode)
                }
        }
        
    }
    
    func deleteDownload(of episode: Episode) {
        do {
            let fileManager = FileManager.default
            try fileManager.removeItem(atPath: fileUrl(for: episode).path)
            clearDownloadData(for: episode)
            delegate?.didReceive(statusUpdate: .removed, for: episode)
        } catch let error as NSError {
            // Couldn't remove (probably not there), so remove from downloaded state
            clearDownloadData(for: episode)
            delegate?.didReceive(statusUpdate: .removed, for: episode)
            print("Couldn't delete the file because of: \(error). Removing record of download. ")
        }
    }
    
    func cancelDownload(of episode: Episode) {
        if let request = downloadRequests[episode.id] {
            request.cancel()
            clearDownloadData(for: episode)
            delegate?.didReceive(statusUpdate: .cancelled, for: episode)
        }
    }
    
    func handle(_ episode: Episode) {
        if isDownloaded(episode.id) {
            deleteDownload(of: episode)
        } else if isDownloading(episode.id) {
            cancelDownload(of: episode)
        } else {
            download(episode)
        }
    }
    
    // Returns if successfully registered
    private func registerDownload(for episode: Episode) {
        downloaded[episode.id] = episode
        downloadRequests.removeValue(forKey: episode.id)
        resumeData.removeValue(forKey: episode.id)
        if !saveAllData() {
            print("Error saving. ")
        }
    }
    
    // Returns if successfully removed
    private func clearDownloadData(for episode: Episode) {
        downloaded.removeValue(forKey: episode.id)
        downloadRequests.removeValue(forKey: episode.id)
        resumeData.removeValue(forKey: episode.id)
        if !saveAllData() {
            print("Error saving. ")
        }
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
                    Cache.sharedInstance.add(episode)
                }
            }
            return true
        }
        return false
    }
    
}
