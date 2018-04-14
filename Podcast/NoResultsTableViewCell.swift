//
//  NoResultsTableViewCell.swift
//  Podcast
//
//  Created by Jack Thompson on 4/14/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit

class NoResultsTableViewCell: UITableViewCell {
    
    static let height:CGFloat = 40
    
    var noResultsLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        
        selectionStyle = .none
        
        noResultsLabel = UILabel()
        noResultsLabel.text = "No Results Found."
        noResultsLabel.textColor = .slateGrey
        noResultsLabel.font = ._14RegularFont()
        noResultsLabel.textAlignment = .center
        addSubview(noResultsLabel)
        
        noResultsLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
