//
//  NoResultsTableViewCell.swift
//  Podcast
//
//  Created by Jack Thompson on 4/14/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit

class NoResultsTableViewCell: UITableViewCell {
    
    static let height:CGFloat = 66
    
    var noResultsLabel: UILabel!
    var searchITunesLabel: UILabel!
    
    let padding: CGFloat = 12
    let itunesPadding: CGFloat = 70
    let itunesLabelHeight:CGFloat = 34
    
    init(style: UITableViewCellStyle, reuseIdentifier: String?, type: SearchType) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        selectionStyle = .none
        
        noResultsLabel = UILabel()
        noResultsLabel.text = "Sorry, no results found."
        noResultsLabel.textColor = .slateGrey
        noResultsLabel.font = ._14RegularFont()
        noResultsLabel.textAlignment = .center
        addSubview(noResultsLabel)
        
        noResultsLabel.snp.makeConstraints { (make) in
            make.top.leading.trailing.equalToSuperview()
        }
        
        searchITunesLabel = UILabel()
        searchITunesLabel.font = ._14RegularFont()
        searchITunesLabel.textColor = .sea
        searchITunesLabel.text = "Search the web to add more series to our collection."
        searchITunesLabel.textAlignment = .center
        searchITunesLabel.numberOfLines = 2
        addSubview(searchITunesLabel)
        
        searchITunesLabel.snp.makeConstraints { (make) in
            make.height.equalTo(itunesLabelHeight)
            make.leading.trailing.equalToSuperview().inset(itunesPadding)
            make.bottom.equalToSuperview()
            make.top.equalTo(noResultsLabel.snp.bottom).offset(padding)
        }
        
        if type != .series {
            searchITunesLabel.isHidden = true
            searchITunesLabel.snp.removeConstraints()
            noResultsLabel.snp.remakeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
