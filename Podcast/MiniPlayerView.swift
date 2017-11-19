
import UIKit

protocol MiniPlayerViewDelegate: class {
    func miniPlayerViewDidTapPlayPauseButton()
    func miniPlayerViewDidTapExpandButton()
    func miniPlayerViewDidDrag(sender: UIPanGestureRecognizer)
}

class MiniPlayerView: UIView {
    
    let miniPlayerHeight: CGFloat = 60.5
    let marginSpacing: CGFloat = 17
    let buttonSize: CGSize = CGSize(width: 18, height: 21.6)
    let buttonTrailingInset: CGFloat = 18
    let arrowYValue: CGFloat = 19.5
    let arrowSize: CGSize = CGSize(width: 17, height: 8.5)
    let titleLabelYValue: CGFloat = 14
    let labelLeadingOffset: CGFloat = 17
    let labelTrailingInset: CGFloat = 60.5
    let labelHeight: CGFloat = 18
    let miniPlayerSliderHeight: CGFloat = 3.5
    
    var arrowButton: UIButton!
    var playPauseButton: UIButton!
    var episodeTitleLabel: UILabel!
    var seriesTitleLabel: UILabel!
    var miniPlayerSlider: UISlider!
    
    var transparentMiniPlayerEnabled: Bool = true
    
    weak var delegate: MiniPlayerViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.frame.size.height = miniPlayerHeight
        backgroundColor = UIColor.gradientWhite.withAlphaComponent(0.85)
        
        if !UIAccessibilityIsReduceTransparencyEnabled() && transparentMiniPlayerEnabled {
            
            backgroundColor = .clear
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            
            blurEffectView.frame = self.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            addSubview(blurEffectView)
        }
        
        miniPlayerSlider = UISlider(frame: .zero)
        miniPlayerSlider.minimumTrackTintColor = .sea
        miniPlayerSlider.maximumTrackTintColor = .silver
        miniPlayerSlider.isUserInteractionEnabled = false
        miniPlayerSlider.setThumbImage(UIImage(), for: .normal)
        addSubview(miniPlayerSlider)
        miniPlayerSlider.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(miniPlayerSliderHeight)
        }
        
        arrowButton = Button()
        arrowButton.setBackgroundImage(#imageLiteral(resourceName: "backArrow"), for: .normal)
        arrowButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        arrowButton.addTarget(self, action: #selector(viewTapped), for: .touchUpInside)
        addSubview(arrowButton)
        arrowButton.snp.makeConstraints { make in
            make.size.equalTo(arrowSize)
            make.leading.equalToSuperview().offset(marginSpacing)
            make.top.equalToSuperview().offset(arrowYValue)
        }
        
        playPauseButton = Button()
        playPauseButton.adjustsImageWhenHighlighted = false
        playPauseButton.addTarget(self, action: #selector(playPauseButtonTapped), for: .touchUpInside)
        playPauseButton.setBackgroundImage(#imageLiteral(resourceName: "play_feed_icon_selected"), for: .selected)
        playPauseButton.setBackgroundImage(#imageLiteral(resourceName: "play_feed_icon"), for: .normal)
        addSubview(playPauseButton)
        playPauseButton.snp.makeConstraints { make in
            make.size.equalTo(buttonSize)
            make.trailing.equalToSuperview().inset(buttonTrailingInset)
            make.top.equalToSuperview().offset(buttonTrailingInset)
        }

        episodeTitleLabel = UILabel(frame: .zero)
        episodeTitleLabel.numberOfLines = 1
        episodeTitleLabel.textAlignment = .left
        episodeTitleLabel.lineBreakMode = .byTruncatingTail
        episodeTitleLabel.textColor = .charcoalGrey
        episodeTitleLabel.font = ._14SemiboldFont()
        addSubview(episodeTitleLabel)
        episodeTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(titleLabelYValue)
            make.height.equalTo(labelHeight)
            make.leading.equalTo(arrowButton.snp.trailing).offset(labelLeadingOffset)
            make.trailing.equalTo(playPauseButton.snp.leading).offset(0 - labelTrailingInset)
        }
        
        seriesTitleLabel = UILabel(frame: .zero)
        seriesTitleLabel.textAlignment = .left
        seriesTitleLabel.textColor = .slateGrey
        seriesTitleLabel.font = ._12RegularFont()
        addSubview(seriesTitleLabel)
        seriesTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(episodeTitleLabel.snp.bottom)
            make.leading.equalTo(arrowButton.snp.trailing).offset(labelLeadingOffset)
            make.trailing.equalTo(playPauseButton.snp.leading).offset(0 - labelTrailingInset)
            make.height.equalTo(labelHeight)
        }

        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(viewTapped(_:))))
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:))))
    }
    
    func updateUIForPlayback(isPlaying: Bool) {
        playPauseButton.isSelected = isPlaying
        miniPlayerSlider.value = Float(Player.sharedInstance.getProgress())
    }
    
    func updateUIForEpisode(episode: Episode) {
        episodeTitleLabel.text = episode.title
        seriesTitleLabel.text = episode.seriesTitle
    }
    
    func updateUIForEmptyPlayer() {
        episodeTitleLabel.text = "No Episode"
        seriesTitleLabel.text = "No Series"
        playPauseButton.setBackgroundImage(#imageLiteral(resourceName: "play_feed_icon"), for: .normal)
    }
    
    @objc func viewTapped(_ sender: UIGestureRecognizer) {
        if sender.isKind(of: UIPanGestureRecognizer.self) {
            delegate?.miniPlayerViewDidDrag(sender: sender as! UIPanGestureRecognizer)
        } else {
            delegate?.miniPlayerViewDidTapExpandButton()
        }
    }
    
    @objc func playPauseButtonTapped() {
        delegate?.miniPlayerViewDidTapPlayPauseButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
