
import UIKit
import CoreMedia

class PlayerViewController: TabBarAccessoryViewController, PlayerDelegate, PlayerHeaderViewDelegate, MiniPlayerViewDelegate, PlayerControlsDelegate, PlayerEpisodeDetailDelegate {
    
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
        view.addSubview(episodeDetailView)

        Player.sharedInstance.delegate = self
        updateUIForEmptyPlayer()
    }
    
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
            if touchPoint.y > 0 && touchPoint.y < view.frame.height - appDelegate.tabBarController.tabBarHeight - miniPlayerView.miniPlayerHeight {
                view.frame = CGRect(x: 0, y: touchPoint.y, width: view.frame.width, height: view.frame.height)
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
                    self.episodeDetailView.alpha = 1
                }, completion: nil)
            }
        default:
            return
        }
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
                    self.episodeDetailView.alpha = 1
                }, completion: nil)
            }
        default:
            return
        }
    }
    
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
            if touchPoint.y < view.frame.height - appDelegate.tabBarController.tabBarHeight - miniPlayerView.miniPlayerHeight {
                episodeDetailView.alpha = 1 - (touchPoint.y/view.frame.height)
                playerHeaderView.alpha = 1 - (touchPoint.y/view.frame.height)
                miniPlayerView.alpha = touchPoint.y/view.frame.height
                view.frame = CGRect(x: 0, y: touchPoint.y, width: view.frame.width, height: view.frame.height)
            }
        case .ended, .cancelled:
            if initialTouchPoint.y - touchPoint.y > 0 {
                appDelegate.expandPlayer(animated: true)
            } else {
                animatePlayer(animations: {
                    self.collapse()
                    self.episodeDetailView.alpha = 0.0
                }, completion: { _ in
                    self.view.backgroundColor = .clear
                })
            }
        default:
            return
        }
    }
    
    func expand() {

        miniPlayerView.alpha = 0.0
        playerHeaderView.alpha = 1.0
        view.frame.origin.y = 0
        UIApplication.shared.isStatusBarHidden = true
        
        isCollapsed = false
    }
    
    func collapse() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        miniPlayerView.alpha = 1.0
        playerHeaderView.alpha = 0.0
        view.frame.origin.y = self.view.frame.height - appDelegate.tabBarController.tabBarHeight - self.miniPlayerView.frame.height
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
            }, completion: { _ in
                self.view.backgroundColor = .clear
                self.episodeDetailView.alpha = 0.0
            })
        } else {
            self.collapse()
        }
    }
    
    // Mark: Player Delegate Methods
    
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
    
    // Mark: PlayerControlsDelegate Methods
    
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
        episode.recommendedChange(completion: controlsView.setRecommendButtonToState)
    }
    
    func playerControlsDidTapMoreButton() {
        guard let episode = Player.sharedInstance.currentEpisode else { return }
        let likeOption = ActionSheetOption(type: .recommend(selected: episode.isRecommended), action: { self.playerControlsDidTapRecommendButton() })
        let bookmarkOption = ActionSheetOption(type: .bookmark(selected: episode.isBookmarked), action: {
            episode.bookmarkChange()
        })
        let downloadOption = ActionSheetOption(type: .download(selected: episode.isDownloaded), action: nil)

        let actionSheetViewController = ActionSheetViewController(options: [likeOption, bookmarkOption, downloadOption], header: nil)
        showActionSheetViewController(actionSheetViewController: actionSheetViewController)
    }
    
}
