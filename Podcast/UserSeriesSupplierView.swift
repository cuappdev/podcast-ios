//
//  SupplierView.swift
//  Podcast
//
//  Created by Natasha Armbrust on 9/18/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import SnapKit

protocol SupplierViewDelegate: class {
    func supplierViewDidPressFeedControlButton(supplierView: UserSeriesSupplierView)
}

class UserSeriesSupplierView: FeedElementSupplierView {
    
    static var height: CGFloat = 52
    
    var lineseparatorHeight: CGFloat = 1
    var contextMarginX: CGFloat = 17
    var contextLabelRightX: CGFloat = 20
    var contextImagesSize: CGFloat = 28
    var feedControlButtonRightX: CGFloat = 20
    var feedControlButtonHieght: CGFloat = 7.5
    var feedControlButtonWidth: CGFloat = 13
    var height: CGFloat = UserSeriesSupplierView.height
    var marginSpacing: CGFloat = 10
    
    ///
    /// Mark: Variables
    ///
    var topLineseparator: UIView!
    var contextLabel: UILabel!
    var contextImages: UIStackView!
    var feedControlButton: FeedControlButton!
    
    weak var delegate: SupplierViewDelegate?
   
    ///
    ///Mark: Init
    ///
    override init() {
        super.init()
        backgroundColor = .offWhite
        
        contextLabel = UILabel(frame: CGRect.zero)
        contextLabel.textAlignment = .left
        contextLabel.lineBreakMode = .byWordWrapping
        contextLabel.font = ._14RegularFont()
        contextLabel.numberOfLines = 2
        addSubview(contextLabel)

        feedControlButton = FeedControlButton()
        feedControlButton.addTarget(self, action: #selector(didPressFeedControlButton), for: .touchUpInside)
        addSubview(feedControlButton)
        
        topLineseparator = UIView(frame: CGRect.zero)
        topLineseparator.backgroundColor = .paleGrey
        addSubview(topLineseparator)
        
        contextImages = UIStackView()
        contextImages.spacing = -1 * contextImagesSize
        addSubview(contextImages)
        
        contextImages.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(contextMarginX)
            make.height.equalTo(contextImagesSize)
            make.centerY.equalToSuperview()
        }
        
        contextLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(contextImages.snp.trailing).offset(marginSpacing)
            make.trailing.equalToSuperview().inset(contextLabelRightX)
        }
        
        feedControlButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(feedControlButtonWidth)
            make.height.equalTo(feedControlButtonHieght)
            make.trailing.equalTo(feedControlButtonRightX)
        }
        
        topLineseparator.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.trailing.equalToSuperview()
            make.leading.equalToSuperview()
            make.height.equalTo(lineseparatorHeight)
        }
        
//        if let users = supplier as? [User] {
//            setupWithUsers(users: users, feedContext: feedContext)
//        }
//
//        if let series = supplier as? Series {
//            setupWithSeries(series: series)
//        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func prepareForReuse() {
        for view in contextImages.subviews {
            view.removeFromSuperview()
        }
    }
    
    func setupWithUsers(users: [User], feedContext: FeedContext) {
        if users != [] {
            contextLabel.text = ""
            users.enumerated().forEach { (i,user) in
                if i >= 3 {
                    return
                }
                contextLabel.text = contextLabel.text! + user.fullName()
                if i != users.count - 1 {
                    contextLabel.text = contextLabel.text! + ", "
                }
                
                let imageView = ImageView(frame: CGRect(x: 0, y: 0, width: contextImagesSize, height: contextImagesSize))
                contextImages.addArrangedSubview(imageView)
                layoutContextImageView(imageView: imageView, imageURL: user.imageURL)
            }
            
            let recommendationType: String
            if case .followingSubscription = feedContext {
                recommendationType = "series"
            } else {
                recommendationType = "episode"
            }
            
            if users.count > 3 {
                contextLabel.text = contextLabel.text! + ", and " + String(users.count - 3) + " others recommended this \(recommendationType)"
            } else {
                contextLabel.text = contextLabel.text! + " recommended this \(recommendationType)"
            }
        }
    }
    
    func setupWithSeries(series: Series) {
        if series.title != "" {
            contextLabel.text = series.title + " released a new episode"
        }
        let imageView = ImageView(frame: CGRect(x: 0, y: 0, width: contextImagesSize, height: contextImagesSize))
        contextImages.addArrangedSubview(imageView)
        layoutContextImageView(imageView: imageView, imageURL: series.smallArtworkImageURL)
    }
    
    internal func layoutContextImageView(imageView: ImageView, imageURL: URL?) {
        imageView.setImageAsynchronouslyWithDefaultImage(url: imageURL)
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.paleGrey.cgColor
        imageView.layer.cornerRadius = contextImagesSize / 2
        imageView.clipsToBounds = true
        imageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(contextImagesSize)
        }
    }
    
    @objc func didPressFeedControlButton() {
        delegate?.supplierViewDidPressFeedControlButton(supplierView: self)
    }
}
