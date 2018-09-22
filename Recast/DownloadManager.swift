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

class DownloadManager: NSObject, URLSessionDelegate, URLSessionDownloadDelegate {

    static let shared = DownloadManager()

    var session: URLSession {
        // Note: by default, allowsCellularAccess is false
        // We can prompt the user in the future if they want to download over cellular
        // and save it in settings somehow
        let configuration = URLSessionConfiguration.background(withIdentifier:
            "\(Bundle.main.bundleIdentifier ?? "").background" )

        // Warning: If an URLSession still exists from a previous download, it doesn't create
        // a new URLSession object but returns the existing one with the old delegate object attached
        return URLSession(configuration: configuration, delegate: self, delegateQueue: OperationQueue())
    }

    var downloadedUrls: [URL: URLSessionDownloadTask] = [:]

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        // save DownloadInfo

    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {

    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let downloadTask = task as? URLSessionDownloadTask {
            // set DownloadInfo state to failed
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                let entity = NSEntityDescription.entity(forEntityName: DownloadInfo.Keys.entityName, in: appDelegate.dataController.managedObjectContext)
                else { return }
            let downloadInfo = NSManagedObject(entity: entity, insertInto: appDelegate.dataController.managedObjectContext)
            downloadInfo.setValue(DownloadInfoStatus.failed.rawValue, forKey: DownloadInfo.Keys.status)
            // How do I coordinate this to the url being downloaded?
        }
    }

    func download(from url: URL) {
        let task = session.downloadTask(with: url)
        downloadedUrls[url] = task
        task.resume()
    }

    func cancel(from url: URL) {
        let task = downloadedUrls[url]
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
            let entity = NSEntityDescription.entity(forEntityName: DownloadInfo.Keys.entityName, in: appDelegate.dataController.managedObjectContext)
            else { return }
        task?.cancel(byProducingResumeData: { resumeData in
            // store resumeData in DownloadInfo
            if let data = resumeData {
                let downloadInfo = NSManagedObject(entity: entity, insertInto: appDelegate.dataController.managedObjectContext)
                downloadInfo.setValuesForKeys([
                    DownloadInfo.Keys.status: DownloadInfoStatus.canceled.rawValue,
                    DownloadInfo.Keys.resumeData: data,
                    ])
            }
        })
    }

    func resume(from url: URL) {
        
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
