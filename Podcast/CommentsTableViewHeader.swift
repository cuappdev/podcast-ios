//
//  CommentTableViewHeader.swift
//  Podcast
//
//  Created by Mark Bryan on 4/12/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

class CommentsTableViewHeader: UIView {
    static let headerHeight: CGFloat = 48
    let commentsLabelXValue: CGFloat = 18
    let commentsLabelYValue: CGFloat = 18
    
    var commentsLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frame.size.height = CommentsTableViewHeader.headerHeight
        backgroundColor = UIColor.colorFromCode(0xf0f1f4)
        
        commentsLabel = UILabel(frame: CGRect(x: commentsLabelXValue, y: commentsLabelYValue, width: 0, height: 0))
        commentsLabel.font = UIFont.boldSystemFont(ofSize: 14)
        commentsLabel.textColor = UIColor.colorFromCode(0x64676c)
        commentsLabel.text = "Comments(243)"
        commentsLabel.sizeToFit()
        addSubview(commentsLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
