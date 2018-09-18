//
//  EpisodeTableViewCell.swift
//  
//
//  Created by Jack Thompson on 9/15/18.
//

import UIKit
import SnapKit

class EpisodeTableViewCell: UITableViewCell {
    
    // MARK: - Variables
    var episodeImageView: UIImageView!
    var episodeNameLabel: UILabel!
    var episodeDescriptionView: UILabel!
    var dateTimeLabel: UILabel!
    
    // MARK: - Constants
    let padding = 5
    let imageHeight = 50
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .white
        
        episodeImageView = UIImageView()
        
        episodeNameLabel = UILabel()
        episodeNameLabel.font = .systemFont(ofSize: 16)
        
        dateTimeLabel = UILabel()
        dateTimeLabel.font = .systemFont(ofSize: 12)
        
        episodeDescriptionView = UILabel()
        episodeDescriptionView.font = .systemFont(ofSize: 14)
        episodeDescriptionView.textAlignment = .left
        episodeDescriptionView.numberOfLines = 3
        
        addSubview(episodeImageView)
        addSubview(episodeNameLabel)
        addSubview(episodeDescriptionView)
        addSubview(dateTimeLabel)
        
        // MARK: - Test data:
        episodeImageView.backgroundColor = .blue
        episodeNameLabel.text = "Episode Title"
        dateTimeLabel.text = "Jan. 1, 2018 • 23:00"
        episodeDescriptionView.text = "This is the episode description. This is the episode description. This is the episode description. This is the episode description. This is the episode description. This is the episode description. This is the episode description."
        
        layoutSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        episodeImageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(padding)
            make.height.width.equalTo(imageHeight)
        }
        
        episodeNameLabel.snp.makeConstraints { make in
            make.top.equalTo(episodeImageView)
            make.left.equalTo(episodeImageView.snp.right).offset(padding)
            make.right.equalToSuperview().inset(padding)
        }
        
        dateTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(episodeNameLabel.snp.bottom)
            make.left.right.equalTo(episodeNameLabel)
        }
        
        episodeDescriptionView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(padding)
            make.right.bottom.equalToSuperview().inset(padding)
            make.top.equalTo(episodeImageView.snp.bottom).offset(padding)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
