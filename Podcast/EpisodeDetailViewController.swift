//
//  EpisodeDetailViewController.swift
//  Podcast
//
//  Created by Mark Bryan on 4/11/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class EpisodeDetailViewController: ViewController, EpisodeDetailHeaderViewDelegate {

    let marginSpacing: CGFloat = EpisodeDetailHeaderView.marginSpacing
    var episode: Episode?
    var headerView: EpisodeDetailHeaderView = EpisodeDetailHeaderView()
    var episodeDescriptionView: UITextView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .offWhite
        
        episodeDescriptionView.isEditable = false
        episodeDescriptionView.font = ._14RegularFont()
        episodeDescriptionView.textColor = .charcoalGrey
        episodeDescriptionView.showsVerticalScrollIndicator = false
        episodeDescriptionView.backgroundColor = .clear
        episodeDescriptionView.textContainerInset = UIEdgeInsetsMake(marginSpacing / 2, marginSpacing, marginSpacing, marginSpacing)
        view.addSubview(episodeDescriptionView)
        mainScrollView = episodeDescriptionView

        view.addSubview(headerView)
        headerView.delegate = self

        headerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().inset(navigationController?.navigationBar.frame.maxY ?? 0)
        }
        
        episodeDescriptionView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        if let episode = episode {
            headerView.setupForEpisode(episode: episode)
            let style = NSMutableParagraphStyle() 
            let attributedDescription = NSMutableAttributedString(attributedString: episode.attributedDescription)
            attributedDescription.addAttribute(NSAttributedStringKey.paragraphStyle, value: style, range: NSMakeRange(0, attributedDescription.length))
            episodeDescriptionView.attributedText = attributedDescription
            // weird known iOS bug when resizing a textContainer's text to be the start of a UITextView .. do not remove
            episodeDescriptionView.isScrollEnabled = false
            episodeDescriptionView.setNeedsUpdateConstraints()
            episodeDescriptionView.isScrollEnabled = true
            
        }
    }

    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //here as well because from ExternalProfileViewController the navigationBar is hidden during viewDidLoad
        headerView.snp.updateConstraints { make in
            make.top.equalToSuperview().inset(navigationController?.navigationBar.frame.maxY ?? 0)
        }
    }
    // EpisodeDetailHeaderViewCellDelegate methods
    
    func episodeDetailHeaderDidPressRecommendButton(view: EpisodeDetailHeaderView) {
        guard let headerEpisode = episode else { return }
        headerEpisode.recommendedChange(completion: view.setRecommendedButtonToState)
    }
    
    func episodeDetailHeaderDidPressMoreButton(view: EpisodeDetailHeaderView) {
        guard let episode = episode else { return }
        let option1 = ActionSheetOption(type: .download(selected: episode.isDownloaded), action: nil)
        var header: ActionSheetHeader?
        
        if let image = view.episodeArtworkImageView.image, let title = view.episodeTitleLabel.text, let description = view.dateLabel.text {
            header = ActionSheetHeader(image: image, title: title, description: description)
        }
        
        let actionSheetViewController = ActionSheetViewController(options: [option1], header: header)
        showActionSheetViewController(actionSheetViewController: actionSheetViewController)
    }
    
    func episodeDetailHeaderDidPressPlayButton(view: EpisodeDetailHeaderView) {
        guard let episode = episode, let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.showPlayer(animated: true)
        Player.sharedInstance.playEpisode(episode: episode)
        view.updateWithPlayButtonPress(episode: episode)
    }
    
    func episodeDetailHeaderDidPressBookmarkButton(view: EpisodeDetailHeaderView) {
        guard let episode = episode else { return }
        let completion = view.setBookmarkButtonToState
        episode.bookmarkChange(completion: completion)
    }
    
    func episodeDetailHeaderDidPressSeriesTitleLabel(view: EpisodeDetailHeaderView) {
        guard let episode = episode else { return }
        let seriesDetailViewController = SeriesDetailViewController()
        seriesDetailViewController.fetchSeries(seriesID: episode.seriesID)
        navigationController?.pushViewController(seriesDetailViewController, animated: true)
    }
    
}
