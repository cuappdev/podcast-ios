//
//  CategoriesCollectionViewCell.swift
//  Podcast
//
//  Created by Natasha Armbrust on 10/2/16.
//  Copyright © 2016 Cornell App Development. All rights reserved.
//

import UIKit

class CategoriesCollectionViewCell: UICollectionViewCell {
    
    //
    // Mark: Constants
    //
    private let labelHeight:CGFloat = 22.0
    private let labelPadding:CGFloat = 4
    private var categoryNameLabel: UILabel!
    
    //
    // Mark: Variables
    //
    var categoryName: String? {
        didSet {
            if let categoryName = categoryName {
                categoryNameLabel.text = categoryName
            }
        }
    }
    
    //
    // Mark: Init
    //
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        
        let yPos = (frame.size.height-labelHeight)/2
        let width = frame.size.width-2*labelPadding
        categoryNameLabel = UILabel(frame: CGRect(x: labelPadding, y: yPos, width: width, height: labelHeight))
        categoryNameLabel.textAlignment = .center
        categoryNameLabel.lineBreakMode = .byWordWrapping
        categoryNameLabel.font = .systemFont(ofSize: 14.0)
        categoryNameLabel.textColor = UIColor.black
        contentView.addSubview(categoryNameLabel)
        
        adjustForScreenSize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    func adjustForScreenSize() {
        let screenWidth = UIScreen.main.bounds.width

        if screenWidth <= 320 { //iphone 5
            categoryNameLabel.font = categoryNameLabel.font.withSize(categoryNameLabel.font.pointSize - 1)
        }
        
        if screenWidth >= 414 { //iphone 6/7 plus
            categoryNameLabel.font = categoryNameLabel.font.withSize(categoryNameLabel.font.pointSize + 2)
        }
    }
}
