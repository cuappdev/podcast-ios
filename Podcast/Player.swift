
import UIKit
import AVFoundation

protocol PlayerDelegate: class {
    func updateUIForEpisode(episode: Episode)
    func updateUIForPlayback()
    func updateUIForEmptyPlayer()
}

class Player: NSObject {
    static let sharedInstance = Player()
    private override init() {
        player = AVPlayer()
        if #available(iOS 10, *) {
            player.automaticallyWaitsToMinimizeStalling = false
        }
        autoplayEnabled = true
        currentItemPrepared = false
        isScrubbing = false
        super.init()
    }
    
    deinit {
        removeCurrentItemStatusObserver()
        removeTimeObservers()
    }
    
    weak var delegate: PlayerDelegate?
    
    // Mark: KVO variables
    
    private var playerItemContext: UnsafeMutableRawPointer?
    private var timeObserverToken: Any?
    
    // Mark: Playback variables/methods
    
    private var player: AVPlayer
    private(set) var currentEpisode: Episode?
    private var autoplayEnabled: Bool
    private var currentItemPrepared: Bool
    var isScrubbing: Bool
    var isPlaying: Bool {
        get {
            return player.rate != 0.0 || (!currentItemPrepared && autoplayEnabled && (player.currentItem != nil))
        }
    }
    
    func playEpisode(episode: Episode) {
        if currentEpisode?.id == episode.id {
            // TODO: decide how to handle this case. do nothing? restart track at beginning?
            //       also, currently all episode ids showing as the same...
        }
        
        guard let url = episode.audioURL else {
            print("Episode \(episode.title) mp3URL is nil. Unable to play.")
            return
        }
        
        if player.status == AVPlayerStatus.failed {
            if let error = player.error {
                print(error)
            }
            player = AVPlayer()
            if #available(iOS 10, *) {
                player.automaticallyWaitsToMinimizeStalling = false
            }
        }
        
        // cleanup any previous AVPlayerItem
        pause()
        removeCurrentItemStatusObserver()
        
        currentEpisode = episode
        reset()
        let asset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset,
                                      automaticallyLoadedAssetKeys: ["playable"])
        playerItem.addObserver(self,
                               forKeyPath: #keyPath(AVPlayerItem.status),
                               options: [.old, .new],
                               context: &playerItemContext)
        player.replaceCurrentItem(with: playerItem)
        delegate?.updateUIForEpisode(episode: currentEpisode!)
        delegate?.updateUIForPlayback()
    }
    
    func play() {
        if let currentItem = player.currentItem {
            if currentItem.status == .readyToPlay {
                player.play()
                addTimeObservers()
            } else {
                autoplayEnabled = true
            }
        }
    }
    
    func pause() {
        if let currentItem = player.currentItem {
            if currentItem.status == .readyToPlay {
                player.pause()
                removeTimeObservers()
            } else {
                autoplayEnabled = false
            }
        }
    }
    
    func togglePlaying() {
        if isPlaying {
            pause()
        } else {
            play()
        }
        delegate?.updateUIForPlayback()
    }
    
    func reset() {
        autoplayEnabled = true
        currentItemPrepared = false
        isScrubbing = false
    }
    
    func skip(seconds: Double) {
        if let currentTime = player.currentItem?.currentTime() {
            let newTime = CMTimeAdd(currentTime, CMTime(seconds: seconds, preferredTimescale: CMTimeScale(1.0)))
            player.currentItem?.seek(to: newTime)
            delegate?.updateUIForPlayback()
        }
    }
    
    func getProgress() -> Double {
        if let currentItem = player.currentItem {
            let currentTime = currentItem.currentTime()
            let durationTime = currentItem.duration
            if !durationTime.isIndefinite && durationTime.seconds != 0 {
                return currentTime.seconds / durationTime.seconds
            }
        }
        return 0.0
    }
    
    func setProgress(progress: Double) {
        if let duration = player.currentItem?.duration {
            if !duration.isIndefinite {
                player.currentItem!.seek(to: CMTime(seconds: duration.seconds * min(max(progress, 0.0), 1.0), preferredTimescale: CMTimeScale(1.0)))
                delegate?.updateUIForPlayback()
            }
        }
    }
    
    // Warning: these next three functions should only be used to set UI element values
    
    func currentItemDuration() -> CMTime {
        guard let duration = player.currentItem?.duration else {
            return CMTime(seconds: 0.0, preferredTimescale: CMTimeScale(1.0))
        }
        return duration.isIndefinite ? CMTime(seconds: 0.0, preferredTimescale: CMTimeScale(1.0)) : duration
    }
    
    func currentItemElapsedTime() -> CMTime {
        return player.currentItem?.currentTime() ?? CMTime(seconds: 0.0, preferredTimescale: CMTimeScale(1.0))
    }
    
    func currentItemRemainingTime() -> CMTime {
        guard let duration = player.currentItem?.duration else {
            return CMTime(seconds: 0.0, preferredTimescale: CMTimeScale(1.0))
        }
        let elapsedTime = currentItemElapsedTime()
        return CMTimeSubtract(duration, elapsedTime)
    }
    
    // Mark: KVO methods
    
    func addTimeObservers() {
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1.0, Int32(NSEC_PER_SEC)), queue: DispatchQueue.main, using: { [weak self] _ in
            self?.delegate?.updateUIForPlayback()
        })
        NotificationCenter.default.addObserver(self, selector: #selector(currentItemDidPlayToEndTime), name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
    }
    
    func removeTimeObservers() {
        guard let token = timeObserverToken else { return }
        player.removeTimeObserver(token)
        timeObserverToken = nil
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
    }
    
    func removeCurrentItemStatusObserver() {
        // observeValue(...) will take care of removing AVPlayerItem.status observer once it is
        // readyToPlay, so we only need to remove observer if AVPlayerItem isn't readyToPlay yet
        if let currentItem = player.currentItem {
            if currentItem.status != .readyToPlay {
                currentItem.removeObserver(self,
                                           forKeyPath: #keyPath(AVPlayer.status),
                                           context: &playerItemContext)
            }
        }
    }
    
    @objc func currentItemDidPlayToEndTime() {
        removeTimeObservers()
        delegate?.updateUIForPlayback()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // Only handle observations for the playerItemContext
        guard context == &playerItemContext else {
            super.observeValue(forKeyPath: keyPath,
                               of: object,
                               change: change,
                               context: context)
            return
        }
        
        if keyPath == #keyPath(AVPlayerItem.status) {
            let status: AVPlayerItemStatus
            
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItemStatus(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }
            
            switch status {
            case .readyToPlay:
                print("AVPlayerItem ready to play")
                currentItemPrepared = true
                if autoplayEnabled { play() }
            case .failed:
                print("Failed to load AVPlayerItem")
            case .unknown:
                print("Unknown AVPlayerItemStatus")
            }
            // remove observer after having reading the AVPlayerItem status
            player.currentItem?.removeObserver(self,
                                               forKeyPath: #keyPath(AVPlayerItem.status),
                                               context: &playerItemContext)
        }
    }
}
