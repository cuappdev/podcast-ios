//
//  Player.swift
//  Podcast
//
//  Created by Mark Bryan on 9/30/16.
//  Copyright © 2016 Cornell App Development. All rights reserved.
//

import UIKit
import AVFoundation

enum PlayerStatus {
    case empty 
    case loading
    case playing
    case paused
    case finished
}

protocol PlayerDelegate: class {
    func playerDidChangeState()
    func playerDidUpdateTime()
}

class Player: NSObject {
    
    static let sharedInstance = Player()
    private override init() {
        playerStatus = .empty
        shouldPlayWhenLoaded = true
        super.init()
    }
    
    var playerStatus: PlayerStatus {
        didSet {
            if oldValue != playerStatus {
                delegate?.playerDidChangeState()
            }
        }
    }
    
    weak var delegate: PlayerDelegate?
    private var shouldPlayWhenLoaded: Bool
    private var playerContext: UnsafeMutableRawPointer?
    private var timeObserverToken: Any?
    private var currentAVPlayer: AVPlayer? {
        didSet {
            oldValue?.pause()
        }
    }
    private var currentEpisode: Episode?
    deinit {
        do {
            try currentAVPlayer?.removeObserver(self, forKeyPath: #keyPath(AVPlayer.status), context: &playerContext)
        } catch {}
        removeTimeObserver()
        removeEndOfItemObserver()
    }
    
    func playEpisode(episode: Episode) {
        if episode.mp3URL == nil || episode == currentEpisode || playerStatus == .loading {
            // currently only support switching episodes when Player isn't already loading
            return
        }
        currentEpisode = episode
        playerStatus = .loading
        currentAVPlayer = AVPlayer(url: episode.mp3URL!)
        currentAVPlayer?.addObserver(self, forKeyPath: #keyPath(AVPlayer.status), options: [.old, .new], context: &playerContext)
    }
    
    func play() {
        guard let player = currentAVPlayer else { return }
        player.play()
        playerStatus = .playing
        addTimeObserver()
        addEndOfItemObserver()
    }
    
    func pause() {
        guard let player = currentAVPlayer else { return }
        player.pause()
        playerStatus = .paused
        removeTimeObserver()
        removeEndOfItemObserver()
    }
    
    func addTimeObserver() {
        guard let player = currentAVPlayer else { return }
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1.0, Int32(NSEC_PER_SEC)), queue: DispatchQueue.main, using: { [weak self] _ in
            self?.delegate?.playerDidUpdateTime()
        })
    }
    
    func removeTimeObserver() {
        guard let token = timeObserverToken, let player = currentAVPlayer else { return }
        
        player.removeTimeObserver(token)
        timeObserverToken = nil
    }
    
    func addEndOfItemObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(currentItemDidFinish), name: .AVPlayerItemDidPlayToEndTime, object: currentAVPlayer?.currentItem)
    }
    
    func removeEndOfItemObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    func togglePlaying() {
        switch playerStatus {
        case .loading:
            shouldPlayWhenLoaded = !shouldPlayWhenLoaded
        case .playing:
            pause()
        case .paused:
            play()
        case .finished:
            setProgress(progress: 0.0)
            play()
        default:
            break
        }
    }
    
    func skip(seconds: Float64) {
        guard let player = currentAVPlayer, playerStatus != .empty || playerStatus != .loading else { return }
        let newTime = CMTimeAdd(player.currentTime(), CMTimeMakeWithSeconds(seconds, Int32(NSEC_PER_SEC)))
        
        // if player had finished and skip is backwards in time, move to a paused state
        if playerStatus == .finished && seconds < 0 {
            playerStatus = .paused
        }
        player.seek(to: newTime)
        delegate?.playerDidUpdateTime()
    }
    
    
    func getProgress() -> Float {
        if playerStatus == .empty || playerStatus == .loading || currentAVPlayer?.currentItem == nil {
            return 0.0
        }
        return Float((currentAVPlayer?.currentItem?.currentTime().seconds)!) / Float((currentAVPlayer?.currentItem?.duration.seconds)!)
    }
    
    func setProgress(progress: Float) {
        if playerStatus == .empty || playerStatus == .loading {
            return
        }
        
        var progress = progress
        
        if progress < 0.0 {
            progress = 0.0
        } else if progress > 1.0 {
            progress = 1.0
        }
        
        if let duration = currentAVPlayer?.currentItem?.duration {
            let newTime = progress * Float(duration.seconds)
            currentAVPlayer?.seek(to: CMTimeMakeWithSeconds(Float64(newTime), Int32(NSEC_PER_SEC)))
            if playerStatus == .finished {
                playerStatus = .paused
            }
        }
    }
    
    func getDuration() -> CMTime? {
        return currentAVPlayer?.currentItem?.duration
    }
    
    func getTimePassed() -> CMTime? {
        if playerStatus == .finished {
            return getDuration()
        }
        return currentAVPlayer?.currentItem?.currentTime()
    }
    
    func getTimeLeft() -> CMTime? {
        guard let timePassed = getTimePassed(), let duration = getDuration() else {
            return nil
        }
        return CMTimeSubtract(duration, timePassed)
    }
    
    func currentItemDidFinish() {
        playerStatus = .finished
        removeEndOfItemObserver()
        delegate?.playerDidChangeState()
        delegate?.playerDidUpdateTime()
    }
    
    func shouldDisplayPlayButton() -> Bool {
        switch playerStatus {
        case .empty, .finished, .paused:
            // equivalend to .paused; should indicate that Player instance has paused playback
            return true
        case .playing:
            return false
        case .loading:
            // equivalent to .playing; in this case, playback is defined 
            // by whether Player will autoplay once track is loaded
            return !shouldPlayWhenLoaded
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard context == &playerContext else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        if keyPath == #keyPath(AVPlayer.status) {
            let status: AVPlayerStatus
            
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerStatus(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }
            
            switch status {
            case .readyToPlay:
                playerStatus = .paused
                if shouldPlayWhenLoaded {
                    togglePlaying()
                }
            case .failed:
                playerStatus = .empty
            default:
                break
            }
            currentAVPlayer?.removeObserver(self, forKeyPath: #keyPath(AVPlayer.status), context: &playerContext)
        }
    }
}
