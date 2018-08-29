
import UIKit
import CoreMedia

class PlayerViewController: TabBarAccessoryViewController, PlayerEpisodeDetailDelegate {
    
    var backgroundImageView: ImageView!
    var controlsView: PlayerControlsView!
    var episodeDetailView: PlayerEpisodeDetailView!
    var playerHeaderView: PlayerHeaderView!
    var miniPlayerView: MiniPlayerView!
    var isCollapsed: Bool = false
    var initialTouchPoint = CGPoint(x: 0, y: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        backgroundImageView = ImageView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        backgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let gradientView = GradientView(frame: view.frame)
        view.addSubview(gradientView)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.frame
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0.1
        view.addSubview(blurEffectView)
        
        playerHeaderView = PlayerHeaderView(frame: .zero)
        playerHeaderView.frame.size.width = view.frame.width
        playerHeaderView.delegate = self
        playerHeaderView.alpha = 0.0
        view.addSubview(playerHeaderView)
        
        miniPlayerView = MiniPlayerView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 0))
        miniPlayerView.frame.size.width = view.frame.width
        miniPlayerView.delegate = self
        view.addSubview(miniPlayerView)
        
        controlsView = PlayerControlsView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 0))
        controlsView.frame.origin.y = view.frame.height - controlsView.frame.size.height
        controlsView.delegate = self
        view.addSubview(controlsView)

        episodeDetailView = PlayerEpisodeDetailView(frame: CGRect(x: 0, y: playerHeaderView.frame.maxY, width: view.frame.width, height: controlsView.frame.minY - playerHeaderView.frame.maxY))
        episodeDetailView.delegate = self
        episodeDetailView.alpha = 0
        view.addSubview(episodeDetailView)

        Player.sharedInstance.delegate = self
        updateUIForEmptyPlayer()
    }
    

    func playerEpisodeDetailViewDidDrag(sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: view.window)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        switch sender.state {
        case .began:
            initialTouchPoint = touchPoint
        case .changed:
            if touchPoint.y - initialTouchPoint.y > 0 {
                view.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y, width: view.frame.width, height: view.frame.height)
                episodeDetailView.alpha = 1 - (touchPoint.y/view.frame.height)
                playerHeaderView.alpha = 1 - (touchPoint.y/view.frame.height)
                miniPlayerView.alpha = touchPoint.y/view.frame.height
                UIApplication.shared.isStatusBarHidden = false
            }
        case .ended, .cancelled:
            if touchPoint.y - initialTouchPoint.y > 0 {
                appDelegate.collapsePlayer(animated: true)
            } else {
                animatePlayer(animations: {
                    self.expand()
                }, completion: nil)
            }
        default:
            return
        }
    }
    
    func playerEpisodeDetailViewDidTapArtwork() {
        
        guard let episode = Player.sharedInstance.currentEpisode else { return }
        
        let seriesDetailViewController = SeriesDetailViewController()
        
        seriesDetailViewController.fetchSeries(seriesID: episode.seriesID)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let tabBarController = appDelegate.tabBarController else { return }
        appDelegate.collapsePlayer(animated: false)
        let navController = tabBarController.selectedViewController as! UINavigationController
        navController.pushViewController(seriesDetailViewController, animated: true)
    }
    
    func expand() {
        miniPlayerView.alpha = 0.0
        playerHeaderView.alpha = 1.0
        episodeDetailView.alpha = 1.0
        backgroundImageView.alpha = 1.0
        view.frame.origin.y = 0
        UIApplication.shared.isStatusBarHidden = true
        
        isCollapsed = false
    }
    
    func collapse() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        miniPlayerView.alpha = 1.0
        playerHeaderView.alpha = 0.0
        episodeDetailView.alpha = 0.0
        backgroundImageView.alpha = 0.0
        view.backgroundColor = .offWhite
        view.frame.origin.y = view.frame.height - appDelegate.tabBarController.tabBar.frame.height - self.miniPlayerView.frame.height
        UIApplication.shared.isStatusBarHidden = false

        isCollapsed = true
    }
    
    func animatePlayer(animations: @escaping () -> Void, completion: ((Bool) -> Void)?) {
        UIView.animate(withDuration: 0.3, animations: animations, completion: completion)
    }
    
    override func accessoryViewFrame() -> CGRect? {
        return miniPlayerView.frame
    }
    
    override func showAccessoryViewController(animated: Bool) {
        if animated {
            animatePlayer(animations: {
                self.view.alpha = 1.0
            }, completion: nil)
        } else {
            view.alpha = 1.0
        }
    }
    
    override func hideAccessoryViewController(animated: Bool) {
        if animated {
            animatePlayer(animations: {
                self.view.alpha = 0.0
            }, completion: nil)
        } else {
            view.alpha = 0.0
        }
    }
    
    override func expandAccessoryViewController(animated: Bool) {
        guard isCollapsed else { return }
        
        view.backgroundColor = .offWhite
        episodeDetailView.alpha = 1.0

        if animated {
            animatePlayer(animations: {
                self.expand()
            }, completion: nil)
        } else {
            self.expand()
        }
    }
    
    override func collapseAccessoryViewController(animated: Bool) {
        guard !isCollapsed else { return }
        
        if animated {
            animatePlayer(animations: {
                self.collapse()
            }, completion: nil)
        } else {
            self.collapse()
        }
    }

}

// MARK: ActionSheetViewController Delegate
extension PlayerViewController: ActionSheetViewControllerDelegate {

    func didPressSegmentedControlForSavePreferences(selected: Bool) {
        Player.sharedInstance.savePreferences = selected
    }

    func didPressSegmentedControlForTrimSilence(selected: Bool) {
        Player.sharedInstance.trimSilence = selected
    }
}

// MARK: Player Delegate
extension PlayerViewController: PlayerDelegate {

    func updateUIForEpisode(episode: Episode) {
        backgroundImageView.setImageAsynchronouslyWithDefaultImage(url: episode.largeArtworkImageURL)
        episodeDetailView.updateUIForEpisode(episode: episode)
        miniPlayerView.updateUIForEpisode(episode: episode)
        controlsView.setRecommendButtonToState(isRecommended: episode.isRecommended, numberOfRecommendations: episode.numberOfRecommendations)
    }
    
    func updateUIForPlayback() {
        let player = Player.sharedInstance
        miniPlayerView.updateUIForPlayback(isPlaying: player.isPlaying)
        controlsView.updateUI(isPlaying: player.isPlaying,
                              elapsedTime: player.currentItemElapsedTime().descriptionText,
                              timeLeft: player.currentItemRemainingTime().descriptionText,
                              progress: Float(player.getProgress()),
                              isScrubbing: player.isScrubbing,
                              rate: player.savedRate)
    }
    
    func updateUIForEmptyPlayer() {
        miniPlayerView.updateUIForEmptyPlayer()
        controlsView.updateUI(isPlaying: false,
                              elapsedTime: "0:00",
                              timeLeft: "0:00",
                              progress: 0.0,
                              isScrubbing: false,
                              rate: .one)
        controlsView.setRecommendButtonToState(isRecommended: false, numberOfRecommendations: 0)
    }

}

// MARK: PlayerHeaderView Delegate
extension PlayerViewController: PlayerHeaderViewDelegate {

    @objc func playerHeaderViewDidTapCollapseButton() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.collapsePlayer(animated: true)
    }

    func playerHeaderViewDidDrag(sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: view.window)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        switch sender.state {
        case .began:
            initialTouchPoint = touchPoint
        case .changed:
            // if the point touched on the player is within the top of the mini player and the top of the screen,
            // adjust the player's height/expansion and transparency
            if touchPoint.y > 0 && touchPoint.y < view.frame.height - appDelegate.tabBarController.tabBar.frame.height - miniPlayerView.miniPlayerHeight {
                view.frame = CGRect(x: 0, y: touchPoint.y, width: view.frame.width, height: view.frame.height)
                episodeDetailView.alpha = 1 - (touchPoint.y/view.frame.height)
                playerHeaderView.alpha = 1 - (touchPoint.y/view.frame.height)
                miniPlayerView.alpha = touchPoint.y/view.frame.height
                UIApplication.shared.isStatusBarHidden = false
            }
            break
        case .ended, .cancelled:
            if touchPoint.y - initialTouchPoint.y > 0 {
                appDelegate.collapsePlayer(animated: true)
            } else {
                animatePlayer(animations: {
                    self.expand()
                    self.episodeDetailView.alpha = 1
                }, completion: nil)
            }
        default:
            return
        }
    }

}

// MARK: MiniPlayerView Delegate
extension PlayerViewController: MiniPlayerViewDelegate {

    func miniPlayerViewDidTapPlayPauseButton() {
        Player.sharedInstance.togglePlaying()
    }

    func miniPlayerViewDidTapExpandButton() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.expandPlayer(animated: true)
    }

    func miniPlayerViewDidDrag(sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: view.window)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        switch sender.state {
        case .began:
            initialTouchPoint = touchPoint
        case .changed:
            if touchPoint.y < view.frame.height - appDelegate.tabBarController.tabBar.frame.height - miniPlayerView.miniPlayerHeight {
                episodeDetailView.alpha = 1 - (touchPoint.y/view.frame.height)
                playerHeaderView.alpha = 1 - (touchPoint.y/view.frame.height)
                miniPlayerView.alpha = touchPoint.y/view.frame.height
                view.frame = CGRect(x: 0, y: touchPoint.y, width: view.frame.width, height: view.frame.height)
            }
            break
        case .ended, .cancelled:
            if initialTouchPoint.y - touchPoint.y > 0 {
                appDelegate.expandPlayer(animated: true)
            } else {
                animatePlayer(animations: {
                    self.collapse()
                }, completion: { _ in
                    self.view.backgroundColor = .clear
                })
            }
        default:
            return
        }
    }

}

// MARK: PlayerControls Delegate
extension PlayerViewController: PlayerControlsDelegate {

    func playerControlsDidTapPlayPauseButton() {
        Player.sharedInstance.togglePlaying()
    }
    
    func playerControlsDidTapSkipBackward() {
        Player.sharedInstance.skip(seconds: -30.0)
    }
    
    func playerControlsDidTapSkipForward() {
        Player.sharedInstance.skip(seconds: 30.0)
    }
    
    func playerControlsDidTapSpeed() {
        // get the current speed of the player and toggle it to the next speed
        let rate = Player.sharedInstance.getSpeed()
        switch rate {
        case .zero_5:
            Player.sharedInstance.setSpeed(rate: .one)
        case .one:
            Player.sharedInstance.setSpeed(rate: .one_25)
        case .one_25:
            Player.sharedInstance.setSpeed(rate: .one_5)
        case .one_5:
            Player.sharedInstance.setSpeed(rate: .one_75)
        case .one_75:
            Player.sharedInstance.setSpeed(rate: .two)
        case .two:
            Player.sharedInstance.setSpeed(rate: .zero_5)
        }
    }
    
    func playerControlsDidSkipNext() {
        // TODO: skip track
    }

    func playerControlsDidScrub() {
        Player.sharedInstance.isScrubbing = true
    }
    
    func playerControlsDidEndScrub() {
        // setProgress now sets scrubbing to be false
        Player.sharedInstance.setProgress(progress: Double(controlsView.slider.value))
    }
    
    func playerControlsDidTapRecommendButton() {
        guard let episode = Player.sharedInstance.currentEpisode else { return }
        recast(for: episode, completion: { _,_ in
          self.controlsView.setRecommendButtonToState(isRecommended: episode.isRecommended, numberOfRecommendations: episode.numberOfRecommendations)
        })
    }

    func playerControlsDidTapSettingsButton() {
        //let rateChangeOption = ActionSheetOption(type: .playerSettingsTrimSilence(selected: Player.sharedInstance.trimSilence), action: nil)
        let saveSettingsOption = ActionSheetOption(type: .playerSettingsCustomizePlayerSettings(selected: Player.sharedInstance.savePreferences), action: nil)
        let actionSheet = ActionSheetViewController(options: [saveSettingsOption], header: nil)
        actionSheet.delegate = self
        showActionSheetViewController(actionSheetViewController: actionSheet)
    }
    
    func playerControlsDidTapMoreButton() {
        guard let episode = Player.sharedInstance.currentEpisode else { return }
        let likeOption = ActionSheetOption(type: .recommend(selected: episode.isRecommended), action: { self.playerControlsDidTapRecommendButton() })
        let bookmarkOption = ActionSheetOption(type: .bookmark(selected: episode.isBookmarked), action: {
            episode.bookmarkChange()
        })
        let downloadOption = ActionSheetOption(type: DownloadManager.shared.actionSheetType(for: episode.id), action: {
            DownloadManager.shared.handle(episode)
        })
        let shareEpisodeOption = ActionSheetOption(type: .shareEpisode, action: {
            guard let user = System.currentUser, let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let viewController = ShareEpisodeViewController(user: user, episode: episode)
            appDelegate.collapsePlayer(animated: false)
            let navController = appDelegate.tabBarController.selectedViewController as! UINavigationController
            navController.pushViewController(viewController, animated: true)
        })

        let actionSheetViewController = ActionSheetViewController(options: [likeOption, bookmarkOption, downloadOption, shareEpisodeOption], header: nil)
        showActionSheetViewController(actionSheetViewController: actionSheetViewController)
    }

}
