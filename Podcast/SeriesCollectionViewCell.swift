//
//  SeriesCollectionViewCell.swift
//  Podcast
//
//  Created by Drew Dunne on 11/16/16.
//  Copyright © 2016 Cornell App Development. All rights reserved.
//

import UIKit

class SeriesCollectionViewCell: UICollectionViewCell {
    
    var seriesImageView: UIImageView!
    
    var seriesImage: UIImage? {
        didSet {
            if let seriesImage = seriesImage {
                seriesImageView.image = seriesImage
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        
        seriesImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        contentView.addSubview(seriesImageView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
}
