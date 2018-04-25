
import UIKit
import AVFoundation
import MediaPlayer
import Kingfisher

class ListeningDuration {
    var id: String
    var currentProgress: Double?
    var percentageListened: Double
    var realDuration: Double?

    init(id: String, currentProgress: Double, percentageListened: Double, realDuration: Double?) {
        self.id = id
        self.currentProgress = currentProgress
        self.percentageListened = percentageListened
        self.realDuration = realDuration
    }
}

protocol PlayerDelegate: class {
    func updateUIForEpisode(episode: Episode)
    func updateUIForPlayback()
    func updateUIForEmptyPlayer()
}

enum PlayerRate: Float {
    case one = 1
    case zero_5 = 0.5
    case one_25 = 1.25
    case one_5 = 1.5
    case one_75 = 1.75
    case two = 2
    
    func toString() -> String {
        switch self {
        case .one, .two:
            return String(Int(self.rawValue)) + "x"
        default:
            return "\(self.rawValue)x"
        }
    }

    // no zero included b/c that's a pause
    static func values() -> [PlayerRate] {
        return [.zero_5, .one, .one_25, .one_5, one_75, .two]
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
        savedRate = .one
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
    private var currentTimeAt: Double = 0.0
    private var currentEpisodePercentageListened: Double = 0.0
    private var nowPlayingInfo: [String: Any]?
    private var artworkImage: MPMediaItemArtwork?
    private var autoplayEnabled: Bool
    private var currentItemPrepared: Bool

    var savePreferences: Bool = false
    var trimSilence: Bool = false
    var listeningDurations: [String: ListeningDuration] = [:]
    var isScrubbing: Bool
    var isPlaying: Bool {
        get {
            return player.rate != 0.0 || (!currentItemPrepared && autoplayEnabled && (player.currentItem != nil))
        }
    }
    var savedRate: PlayerRate

    func resetUponLogout() {
        saveListeningDurations()
        listeningDurations = [:]
        reset()
        pause()
    }
    
    func playEpisode(episode: Episode) {
        if currentEpisode?.id == episode.id {
            currentEpisode?.currentProgress = getProgress()
            // if the same episode was set we just toggle the player
            togglePlaying()
            return
        }

        saveListeningDurations()

        // save preferences
        if let currentUser = System.currentUser, let seriesId = currentEpisode?.seriesID {
            if savePreferences {
                let prefs = SeriesPreferences(playerRate: savedRate, trimSilences: trimSilence)
                UserPreferences.savePreference(preference: prefs, for: currentUser, and: seriesId)
            } else { // we aren't saving prefs
                UserPreferences.removePreference(for: currentUser, and: seriesId)
            }
        }
        
        var url: URL?
        if episode.isDownloaded {
            if let filepath = episode.fileURL {
                url = filepath
            } else if let httpURL = episode.audioURL {
                url = httpURL
            }
        } else {
            if let httpURL = episode.audioURL {
                url = httpURL
            }
        }
        guard let u = url else {
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

        if let listeningDuration = listeningDurations[episode.id] { // if we've played this episode before
            if let currentProgress = listeningDuration.currentProgress {
                currentTimeAt = currentProgress // played this episode before and have valid current progress
            } else {
                currentTimeAt = 0.0
            }
        } else { // never played this episode before, use episodes saved currentProgress
            listeningDurations[episode.id] = ListeningDuration(id: episode.id, currentProgress: episode.currentProgress, percentageListened: 0, realDuration: nil)
            currentTimeAt = episode.currentProgress
        }

        // swap epsiodes
        currentEpisode?.isPlaying = false
        episode.isPlaying = true
        currentEpisode = episode

        updateNowPlayingArtwork()
        reset()

        // load saved preferences for this series if they exist
        if let savedPref = UserPreferences.userToSeriesPreference(for: System.currentUser!, seriesId: currentEpisode!.seriesID) {
            savedRate = savedPref.playerRate
            trimSilence = savedPref.trimSilences
            savePreferences = true
        }


        let asset = AVAsset(url: u)
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
                setProgress(progress: currentTimeAt, completion: {
                    self.player.play()
                    self.player.rate = self.savedRate.rawValue
                })
                setSpeed(rate: savedRate)
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
                currentTimeAt = getProgress()
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
        setSpeed(rate: UserPreferences.defaultPlayerRate)
        savePreferences = false
        trimSilence = false
    }
    
    func skip(seconds: Double) {
        guard let currentItem = player.currentItem else { return }
        let newTime = CMTimeAdd(currentItem.currentTime(), CMTime(seconds: seconds, preferredTimescale: CMTimeScale(1.0)))
        player.currentItem?.seek(to: newTime, completionHandler: { success in
            self.currentTimeAt = self.getProgress()
            self.updateNowPlayingInfo()
        })
        
        if newTime > CMTime(seconds: 0.0, preferredTimescale: CMTimeScale(1.0)) {
            self.currentTimeAt = self.getProgress()
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

    func getDuration() -> Double {
        guard let currentItem = player.currentItem else { return 0.0 }
        return currentItem.duration.seconds
    }
    
    func setProgress(progress: Double, completion: (() -> ())? = nil) {
        if let duration = player.currentItem?.duration {
            if !duration.isIndefinite {
                player.currentItem!.seek(to: CMTime(seconds: duration.seconds * min(max(progress, 0.0), 1.0), preferredTimescale: CMTimeScale(1.0)), completionHandler: { (_) in
                    completion?()
                    self.isScrubbing = false
                    self.currentTimeAt = self.getProgress()
                    self.delegate?.updateUIForPlayback()
                    self.updateNowPlayingInfo()
                })
            }
        }
    }
    
    func seekTo(_ position: TimeInterval) {
        if let _ = player.currentItem {
            updateCurrentPercentageListened()
            let newPosition = CMTimeMakeWithSeconds(position, 1)
            player.seek(to: newPosition, toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero, completionHandler: { (_) in
                self.currentTimeAt = self.getProgress()
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
        
        var nowPlayingInfo = [
            MPMediaItemPropertyTitle: episode.title,
            MPMediaItemPropertyArtist: episode.seriesTitle,
            MPMediaItemPropertyAlbumTitle: episode.seriesTitle,
            MPNowPlayingInfoPropertyPlaybackRate: NSNumber(value: savedRate.rawValue),
            MPNowPlayingInfoPropertyElapsedPlaybackTime: NSNumber(value: CMTimeGetSeconds(currentItemElapsedTime())),
            MPMediaItemPropertyPlaybackDuration: NSNumber(value: CMTimeGetSeconds(currentItemDuration())),
        ] as [String : Any]
        
        if let image = artworkImage {
            nowPlayingInfo[MPMediaItemPropertyArtwork] = image
        }
        configureNowPlaying(info: nowPlayingInfo)
    }
    
    // Updates the now playing artwork.
    func updateNowPlayingArtwork() {
        guard let episode = currentEpisode, let url = episode.smallArtworkImageURL else {
            return
        }
        
        ImageCache.default.retrieveImage(forKey: episode.id, options: nil) {
            image, cacheType in
            if let image = image {
                //In this code snippet, the `cacheType` is .disk
                self.artworkImage = MPMediaItemArtwork(boundsSize: CGSize(width: image.size.width, height: image.size.height), requestHandler: { _ in
                    image
                })
                self.updateNowPlayingInfo()
            } else {
                ImageDownloader.default.downloadImage(with: url, options: [], progressBlock: nil) {
                    (imageDown, error, url, data) in
                    if let imageDown = imageDown {
                        ImageCache.default.store(imageDown, forKey: episode.id)
                        self.artworkImage = MPMediaItemArtwork(boundsSize: CGSize(width: imageDown.size.width, height: imageDown.size.height), requestHandler: { _ in
                            imageDown
                        })
                        self.updateNowPlayingInfo()
                    }
                }
            }
        }
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
                return
            case .unknown:
                print("Unknown AVPlayerItemStatus")
                return
            }
            // remove observer after having reading the AVPlayerItem status
            player.currentItem?.removeObserver(self,
                                               forKeyPath: #keyPath(AVPlayerItem.status),
                                               context: &playerItemContext)
        }
    }

    func updateCurrentPercentageListened() {
        currentEpisodePercentageListened += abs(getProgress() - currentTimeAt)
        currentTimeAt = getProgress()
    }

    func saveListeningDurations() {
        if let current = currentEpisode {
            if let listeningDuration = listeningDurations[current.id] {
                listeningDuration.currentProgress = getProgress().isNaN ? nil : getProgress()
                current.currentProgress = listeningDuration.currentProgress != nil ? listeningDuration.currentProgress! : current.currentProgress
                listeningDuration.realDuration = getDuration().isNaN ? nil : getDuration() // don't send invalid duration
                updateCurrentPercentageListened()
                listeningDuration.percentageListened = listeningDuration.percentageListened + currentEpisodePercentageListened
                currentEpisodePercentageListened = 0
            } else {
                print("Trying to save an episode never played before: \(current.title)")
            }
        }
        let endpointRequest = SaveListeningDurationEndpointRequest(listeningDurations: listeningDurations)
        endpointRequest.success = { _ in
            print("Successfully saved listening duration history")
        }
        endpointRequest.failure = { _ in
            print("Unsuccesfully saved listening duration history")
        }
        System.endpointRequestQueue.addOperation(endpointRequest)
    }
}
