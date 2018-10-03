//
//  DownloadManager.swift
//  Recast
//
//  Created by Mindy Lou on 9/17/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import Foundation
import CoreData
import UIKit

// Notification names for receiving download progress
// Views can register to listen for these notifications
extension Notification.Name {
    static let didCompleteDownload = Notification.Name("didCompleteDownload")
    static let didFailDownload = Notification.Name("didFailDownload")
    static let didUpdateDownloadProgress = Notification.Name("didUpdateDownloadProgress")
}

class DownloadManager: NSObject {

    static let shared = DownloadManager()

    private override init() {
        super.init()
    }

    private var session: URLSession {
        // Note: by default, allowsCellularAccess is false
        // We can prompt the user in the future if they want to download over cellular
        // and save it in settings somehow
        let configuration = URLSessionConfiguration.background(withIdentifier:
            "\(Bundle.main.bundleIdentifier ?? "").background" )
        configuration.httpMaximumConnectionsPerHost = 5 // Maximum 5 downloads at once

        // Warning: If an URLSession still exists from a previous download, it doesn't create
        // a new URLSession object but returns the existing one with the old delegate object attached
        return URLSession(configuration: configuration, delegate: self, delegateQueue: OperationQueue())
    }

    /// Maps task handling the download to the download task
    private var downloadedUrls: [URLSessionDownloadTask: URL] = [:]

    func download(episode: EpisodeMO) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let entity = NSEntityDescription.entity(forEntityName: DownloadInfo.Keys.entityName,
                                                    in: appDelegate.dataController.managedObjectContext),
            let url = episode.audioURL else { return }

        let task = session.downloadTask(with: url)
        downloadedUrls[task] = url
        let downloadInfo = NSManagedObject(entity: entity, insertInto: appDelegate.dataController.managedObjectContext)
        downloadInfo.setValuesForKeys([
            DownloadInfo.Keys.progress: 0,
            DownloadInfo.Keys.identifier: task.taskIdentifier,
            DownloadInfo.Keys.episode: episode
            ])
        episode.setValue(downloadInfo, forKey: EpisodeMO.Keys.downloadInfo)
        saveData()
        task.resume()
    }

    func cancel(episode: EpisodeMO) {
        guard let url = episode.audioURL else { return }
        // swiftlint:disable:next opening_brace
        let taskForURL = downloadedUrls.filter{ $0.value == url }.map{ $0.key }.first
        guard let task = taskForURL else { return }
        task.cancel(byProducingResumeData: { resumeData in
            // store resumeData in DownloadInfo
            if let data = resumeData,
                let downloadInfo = DownloadInfo.fetchDownloadInfo(with: task.taskIdentifier) {
                let progress = Float(task.countOfBytesReceived) / Float(task.countOfBytesExpectedToReceive)
                downloadInfo.setValuesForKeys([
                    DownloadInfo.Keys.resumeData: data,
                    DownloadInfo.Keys.status: DownloadInfoStatus.canceled,
                    DownloadInfo.Keys.progress: progress
                    ])
                self.saveData()
            }
        })
    }

    func resume(episode: EpisodeMO) {
        guard let url = episode.audioURL, let downloadInfo = episode.downloadInfo,
            let resumeData = downloadInfo.resumeData else { return }
        let task = session.downloadTask(withResumeData: resumeData)
        downloadedUrls[task] = url
        downloadInfo.setValue(task.taskIdentifier, forKey: DownloadInfo.Keys.identifier)
        saveData()
        task.resume()
    }

    func saveData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        do {
            try appDelegate.dataController.managedObjectContext.save()
        } catch {
            print("Error saving data to context")
        }
    }

}

// MARK: - URLSessionDownload Delegate
extension DownloadManager: URLSessionDownloadDelegate {

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let entity = NSEntityDescription.entity(forEntityName: DownloadInfo.Keys.entityName,
                                                    in: appDelegate.dataController.managedObjectContext),
            let downloadURL = downloadedUrls[downloadTask]
            else { return }
        let downloadInfo = NSManagedObject(entity: entity, insertInto: appDelegate.dataController.managedObjectContext)
        downloadInfo.setValuesForKeys([
            DownloadInfo.Keys.downloadedAt: Date(), // Current time
            DownloadInfo.Keys.path: location.path,
            DownloadInfo.Keys.sizeInBytes: downloadTask.countOfBytesReceived,
            DownloadInfo.Keys.status: DownloadInfoStatus.succeeded
            ])
        saveData()
        // Send notification that download is complete
        // Do we need to send user info?
        let userInfoDict = ["url": downloadURL]
        NotificationCenter.default.post(name: .didCompleteDownload, object: nil, userInfo: userInfoDict)
    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        if let downloadURL = downloadedUrls[downloadTask], totalBytesExpectedToWrite > 0 {
            let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
            let userInfoDict: [String: Any] = ["progress": progress, "url": downloadURL]
            // Send download progress notification
            NotificationCenter.default.post(name: .didUpdateDownloadProgress, object: nil, userInfo: userInfoDict)
        }
    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        // Fetch download info by identifier
        if let downloadInfo = DownloadInfo.fetchDownloadInfo(with: task.taskIdentifier) {
            downloadInfo.setValue(DownloadInfoStatus.failed, forKey: DownloadInfo.Keys.status)
            saveData()
        }
        // Send notification about error
        guard let downloadTask = task as? URLSessionDownloadTask,
            let downloadURL = downloadedUrls[downloadTask] else { return }
        let userInfoDict = ["url": downloadURL]
        NotificationCenter.default.post(name: .didFailDownload, object: nil, userInfo: userInfoDict)
    }

}
