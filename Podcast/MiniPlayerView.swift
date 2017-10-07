
import UIKit

protocol MiniPlayerViewDelegate: class {
    func miniPlayerViewDidTapPlayPauseButton()
    func miniPlayerViewDidTapExpandButton()
}

class MiniPlayerView: UIView {
    
    let miniPlayerHeight: CGFloat = 58
    let marginSpacing: CGFloat = 24
    let buttonDimension: CGFloat = 24
    let arrowYValue: CGFloat = 25
    let arrowWidth: CGFloat = 16
    let arrowHeight: CGFloat = 8
    let labelYVal: CGFloat = 12
    let labelHeight: CGFloat = 34
    
    var arrowButton: UIButton!
    var playPauseButton: UIButton!
    var episodeTitleLabel: UILabel!
    
    var transparentMiniPlayerEnabled: Bool = true
    
    weak var delegate: MiniPlayerViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame.size.height = miniPlayerHeight
        backgroundColor = .lightGrey
        
        if !UIAccessibilityIsReduceTransparencyEnabled() && transparentMiniPlayerEnabled {
            
            self.backgroundColor = UIColor.clear
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            
            blurEffectView.frame = self.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            self.addSubview(blurEffectView)
        }
        
        arrowButton = UIButton(frame: CGRect(x: marginSpacing, y: arrowYValue, width: arrowWidth, height: arrowHeight))
        arrowButton.setBackgroundImage(#imageLiteral(resourceName: "down_arrow_icon"), for: .normal)
        arrowButton.addTarget(self, action: #selector(viewTapped), for: .touchUpInside)
        addSubview(arrowButton)
        
        playPauseButton = UIButton(frame: CGRect(x: frame.size.width - marginSpacing - buttonDimension, y: 17, width: buttonDimension, height: buttonDimension))
        playPauseButton.adjustsImageWhenHighlighted = false
        playPauseButton.addTarget(self, action: #selector(playPauseButtonTapped), for: .touchUpInside)
        addSubview(playPauseButton)
        
        episodeTitleLabel = UILabel(frame: CGRect(x: arrowButton.frame.maxX + marginSpacing, y: labelYVal, width: playPauseButton.frame.minX - 2 * marginSpacing - arrowButton.frame.maxX, height: 34))
        episodeTitleLabel.numberOfLines = 2
        episodeTitleLabel.textAlignment = .left
        episodeTitleLabel.lineBreakMode = .byWordWrapping
        addSubview(episodeTitleLabel)
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))
    }
    
    func updateUIForPlayback(isPlaying: Bool) {
        if isPlaying {
            playPauseButton.setBackgroundImage(#imageLiteral(resourceName: "player_pause_icon"), for: .normal)
        } else {
            playPauseButton.setBackgroundImage(#imageLiteral(resourceName: "player_play_icon"), for: .normal)
        }
    }
    
    func updateUIForEpisode(episode: Episode) {
        episodeTitleLabel.text = episode.title
    }
    
    func updateUIForEmptyPlayer() {
        episodeTitleLabel.text = "No Episode"
        playPauseButton.setBackgroundImage(#imageLiteral(resourceName: "player_play_icon"), for: .normal)
    }
    
    @objc func viewTapped() {
        delegate?.miniPlayerViewDidTapExpandButton()
    }
    
    @objc func playPauseButtonTapped() {
        delegate?.miniPlayerViewDidTapPlayPauseButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
