//
//  DownloadManager.swift
//  Recast
//
//  Created by Mindy Lou on 9/17/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import Foundation

class DownloadManager: NSObject, URLSessionDelegate, URLSessionDownloadDelegate {

    static let shared = DownloadManager()

    var session: URLSession {
        get {
            let configuration = URLSessionConfiguration.background(withIdentifier: "\(Bundle.main.bundleIdentifier ?? "").background" )

            // Warning: If an URLSession still exists from a previous download, it doesn't create
            // a new URLSession object but returns the existing one with the old delegate object attached
            return URLSession(configuration: configuration, delegate: self, delegateQueue: OperationQueue())
        }
    }

    var dict: [URL: URLSessionTask] = [:]

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {

    }

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {

    }

    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {

    }

    func download(from url: URL) {
        let task = session.downloadTask(with: url)
        dict[url] = task
        task.resume()
    }

}
