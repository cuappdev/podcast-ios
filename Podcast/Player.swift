
import UIKit
import AVFoundation
import MediaPlayer

protocol PlayerDelegate: class {
    func updateUIForEpisode(episode: Episode)
    func updateUIForPlayback()
    func updateUIForEmptyPlayer()
}

enum PlayerRate: Float {
    case normal = 1.0
    case slow = 0.5
    case fast = 1.5
    
    func toString() -> String {
        switch self {
        case .normal:
            return "1x"
        case .slow:
            return "0.5x"
        case .fast:
            return "1.5x"
        }
    }
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
        savedRate = .normal
        super.init()
        
        configureCommands()
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
    private var nowPlayingInfo: [String: Any]?
    private var autoplayEnabled: Bool
    private var currentItemPrepared: Bool
    var isScrubbing: Bool
    var isPlaying: Bool {
        get {
            return player.rate != 0.0 || (!currentItemPrepared && autoplayEnabled && (player.currentItem != nil))
        }
    }
    var savedRate: PlayerRate
    
    func playEpisode(episode: Episode) {
        if currentEpisode?.id == episode.id {
            // TODO: decide how to handle this case. do nothing? restart track at beginning?
            self.pause()
        }
        
        episode.createListeningHistory() //endpoint request 
        
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
        
        if let current = currentEpisode {
            current.isPlaying = false
        }
        episode.isPlaying = true
        currentEpisode = episode
        reset()
        let asset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset, automaticallyLoadedAssetKeys: ["playable"])
        playerItem.addObserver(self,
                               forKeyPath: #keyPath(AVPlayerItem.status),
                               options: [.old, .new],
                               context: &playerItemContext)
        player.replaceCurrentItem(with: playerItem)
        updateNowPlayingInfo()
        delegate?.updateUIForEpisode(episode: currentEpisode!)
        delegate?.updateUIForPlayback()
    }
    
    @objc func play() {
        if let currentItem = player.currentItem {
            if currentItem.status == .readyToPlay {
                try! AVAudioSession.sharedInstance().setActive(true)
                player.play()
                player.rate = savedRate.rawValue
                delegate?.updateUIForPlayback()
                updateNowPlayingInfo()
                addTimeObservers()
            } else {
                autoplayEnabled = true
            }
        }
    }
    
    @objc func pause() {
        if let currentItem = player.currentItem {
            guard let rate = PlayerRate(rawValue: player.rate) else { return }
            if currentItem.status == .readyToPlay {
                savedRate = rate
                player.pause()
                updateNowPlayingInfo()
                removeTimeObservers()
                delegate?.updateUIForPlayback()
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
        player.rate = 1.0
    }
    
    func skip(seconds: Double) {
        guard let currentItem = player.currentItem else { return }
        let newTime = CMTimeAdd(currentItem.currentTime(), CMTime(seconds: seconds, preferredTimescale: CMTimeScale(1.0)))
        player.currentItem?.seek(to: newTime, completionHandler: { success in
            self.updateNowPlayingInfo()
        })
        
        if newTime > CMTime(seconds: 0.0, preferredTimescale: CMTimeScale(1.0)) {
            delegate?.updateUIForPlayback()
        }
    }
    
    func setSpeed(rate: PlayerRate) {
        savedRate = rate
        if isPlaying {
            player.rate = rate.rawValue
        }
        delegate?.updateUIForPlayback()
    }
    
    func getSpeed() -> PlayerRate {
        return savedRate
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
                player.currentItem!.seek(to: CMTime(seconds: duration.seconds * min(max(progress, 0.0), 1.0), preferredTimescale: CMTimeScale(1.0)), completionHandler: { (_) in
                    self.isScrubbing = false
                    self.delegate?.updateUIForPlayback()
                    self.updateNowPlayingInfo()
                })
            }
        }
    }
    
    func seekTo(_ position: TimeInterval) {
        if let _ = player.currentItem {
            let newPosition = CMTimeMakeWithSeconds(position, 1)
            player.seek(to: newPosition, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero, completionHandler: { (_) in
                self.delegate?.updateUIForPlayback()
                self.updateNowPlayingInfo()
            })
        }
    }
    
    // Configures the Remote Command Center for our player. Should only be called once (in init)
    func configureCommands() {
        UIApplication.shared.beginReceivingRemoteControlEvents()
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.pauseCommand.addTarget(self, action: #selector(Player.pause))
        commandCenter.playCommand.addTarget(self, action: #selector(Player.play))
        commandCenter.skipForwardCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            self.skip(seconds: 30)
            return .success
        }
        commandCenter.skipForwardCommand.preferredIntervals = [30]
        commandCenter.skipBackwardCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            self.skip(seconds: -30)
            return .success
        }
        commandCenter.skipBackwardCommand.preferredIntervals = [30]
        commandCenter.changePlaybackPositionCommand.addTarget(self, action: #selector(Player.handleChangePlaybackPositionCommandEvent(event:)))
    }
    
    @objc func handleChangePlaybackPositionCommandEvent(event: MPChangePlaybackPositionCommandEvent) -> MPRemoteCommandHandlerStatus {
        seekTo(event.positionTime)
        return .success
    }
    
    // Updates information in Notfication Center/Lockscreen info
    func updateNowPlayingInfo() {
        guard let episode = currentEpisode else {
            configureNowPlaying(info: nil)
            return
        }
        
        let nowPlayingInfo = [
            MPMediaItemPropertyTitle: episode.title,
            MPMediaItemPropertyArtist: episode.seriesTitle,
            MPMediaItemPropertyAlbumTitle: episode.seriesTitle,
            MPNowPlayingInfoPropertyPlaybackRate: NSNumber(value: savedRate.rawValue),
            MPNowPlayingInfoPropertyElapsedPlaybackTime: NSNumber(value: CMTimeGetSeconds(currentItemElapsedTime())),
            MPMediaItemPropertyPlaybackDuration: NSNumber(value: CMTimeGetSeconds(currentItemDuration()))
        ] as [String : Any]
        
//        let imageCache = HNKCache.shared()
//        let fetcher = HNKNetworkFetcher(url: episode.smallArtworkImageURL)
//        imageCache?.fetchImage(for: fetcher, formatName: episode.id, success: { image in
//            if var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo, let image = image {
//                nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(image: image)
//            }
//        }, failure: { image in })
        
        configureNowPlaying(info: nowPlayingInfo)
    }
    
    // Configures the MPNowPlayingInfoCenter
    func configureNowPlaying(info: [String : Any]?) {
        self.nowPlayingInfo = info
        MPNowPlayingInfoCenter.default().nowPlayingInfo = info
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
