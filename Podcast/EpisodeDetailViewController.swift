//
//  EpisodeDetailViewController.swift
//  Podcast
//
//  Created by Mark Bryan on 4/11/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class EpisodeDetailViewController: UIViewController {
    var episodeDetailHeaderView: EpisodeDetailHeaderView!
    var episode: Episode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        episodeDetailHeaderView = EpisodeDetailHeaderView(frame: CGRect(x: 0, y: navigationController?.navigationBar.frame.maxY ?? 0, width: self.view.frame.width, height: 0))
        view.addSubview(episodeDetailHeaderView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let episode = episode else { return }
        episodeDetailHeaderView.setupForEpisode(episode: episode)
    }
    
}
