
import UIKit
import CoreMedia

class PlayerViewController: TabBarAccessoryViewController, PlayerDelegate, PlayerHeaderViewDelegate, MiniPlayerViewDelegate, PlayerControlsDelegate {
    
    var controlsView: PlayerControlsView!
    var episodeDetailView: PlayerEpisodeDetailView!
    var playerHeaderView: PlayerHeaderView!
    var miniPlayerView: MiniPlayerView!
    var isCollapsed: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        playerHeaderView = PlayerHeaderView(frame: .zero)
        playerHeaderView.frame.size.width = view.frame.width
        playerHeaderView.delegate = self
        playerHeaderView.alpha = 0.0
        view.addSubview(playerHeaderView)
        
        miniPlayerView = MiniPlayerView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 0))
        miniPlayerView.frame.size.width = view.frame.width
        miniPlayerView.delegate = self
        view.addSubview(miniPlayerView)
        
        episodeDetailView = PlayerEpisodeDetailView(frame: .zero)
        episodeDetailView.frame.size.width = view.frame.width
        episodeDetailView.frame.origin.y = playerHeaderView.frame.maxY
        view.addSubview(episodeDetailView)
        
        controlsView = PlayerControlsView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 0))
        controlsView.frame.origin.y = view.frame.height - controlsView.frame.size.height
        controlsView.delegate = self
        view.addSubview(controlsView)
        
        Player.sharedInstance.delegate = self
        updateUIForEmptyPlayer()
    }
    
    func playerHeaderViewDidTapCollapseButton() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.collapsePlayer(animated: true)
    }
    
    func miniPlayerViewDidTapPlayPauseButton() {
       Player.sharedInstance.togglePlaying()
    }
    
    func miniPlayerViewDidTapExpandButton() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.expandPlayer(animated: true)
    }
    
    func expand() {

        miniPlayerView.alpha = 0.0
        playerHeaderView.alpha = 1.0
        view.frame.origin.y = 0
        
        isCollapsed = false
    }
    
    func collapse() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        miniPlayerView.alpha = 1.0
        playerHeaderView.alpha = 0.0
        view.frame.origin.y = self.view.frame.height - appDelegate.tabBarController.tabBarHeight - self.miniPlayerView.frame.height

        isCollapsed = true
    }
    
    override func accessoryViewFrame() -> CGRect? {
        return miniPlayerView.frame
    }
    
    override func showAccessoryViewController(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.5, animations: {
                self.view.alpha = 1.0
            })
        } else {
            view.alpha = 1.0
        }
    }
    
    override func hideAccessoryViewController(animated: Bool) {
        
        if animated {
            UIView.animate(withDuration: 0.5, animations: {
                self.view.alpha = 0.0
            })
        } else {
            view.alpha = 0.0
        }
    }
    
    override func expandAccessoryViewController(animated: Bool) {
        guard isCollapsed else { return }
        
        view.backgroundColor = .white
        episodeDetailView.alpha = 1.0
        
        if animated {
            UIView.animate(withDuration: 0.5, animations: {
                self.expand()
            })
        } else {
            self.expand()
        }
    }
    
    override func collapseAccessoryViewController(animated: Bool) {
        guard !isCollapsed else { return }
        
        if animated {
            UIView.animate(withDuration: 0.5, animations: { 
                self.collapse()
            }, completion: { (complete: Bool) in
                self.view.backgroundColor = .clear
                self.episodeDetailView.alpha = 0.0
            })
        } else {
            self.collapse()
        }
    }
    
    // Mark: Player Delegate Methods
    
    func updateUIForEpisode(episode: Episode) {
        episodeDetailView.updateUIForEpisode(episode: episode)
        miniPlayerView.updateUIForEpisode(episode: episode)
    }
    
    func updateUIForPlayback() {
        let player = Player.sharedInstance
        miniPlayerView.updateUIForPlayback(isPlaying: player.isPlaying)
        controlsView.updateUI(isPlaying: player.isPlaying,
                              elapsedTime: player.currentItemElapsedTime().descriptionText,
                              timeLeft: player.currentItemRemainingTime().descriptionText,
                              progress: Float(player.getProgress()),
                              isScrubbing: player.isScrubbing)
    }
    
    func updateUIForEmptyPlayer() {
        miniPlayerView.updateUIForEmptyPlayer()
        playerHeaderView.updateUI()
        episodeDetailView.updateUIForEmptyPlayer()
        controlsView.updateUI(isPlaying: false,
                              elapsedTime: "0:00",
                              timeLeft: "0:00",
                              progress: 0.0,
                              isScrubbing: false)
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
    
    func playerControlsDidScrub() {
        Player.sharedInstance.isScrubbing = true
    }
    
    func playerControlsDidEndScrub() {
        Player.sharedInstance.isScrubbing = false
        Player.sharedInstance.setProgress(progress: Double(controlsView.slider.value))
    }
    
}
