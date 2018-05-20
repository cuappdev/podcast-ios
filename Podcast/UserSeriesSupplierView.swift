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
    func didPressFeedControlButton(for supplierView: UserSeriesSupplierView)
}

class UserSeriesSupplierView: UIView {
    
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
    var recastImageSize: CGFloat = 18
    var smallMarginSpacing: CGFloat = 6
    
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
    init() {
        super.init(frame: .zero)
        
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
        topLineseparator.isHidden = true // new designs don't have this but we might add it back in
        
        contextImages = UIStackView()
        contextImages.spacing = smallMarginSpacing

        addSubview(contextImages)
        
        contextImages.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(contextMarginX)
            make.height.equalTo(contextImagesSize)
            make.centerY.equalToSuperview()
        }
        
        contextLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(contextImages.snp.trailing).offset(marginSpacing).priority(999)
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupWithUser(user: User, feedContext: FeedContext) {
        contextImages.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let contextString = NSMutableAttributedString()

        var name = NSAttributedString(string: user.fullName(), attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: contextLabel.font.pointSize)])

        if user.id == System.currentUser!.id {
            name = NSAttributedString(string: "You", attributes: [.font: UIFont.boldSystemFont(ofSize: contextLabel.font.pointSize)])
        }

        let imageView = ImageView(frame: CGRect(x: 0, y: 0, width: contextImagesSize, height: contextImagesSize))
        contextImages.addArrangedSubview(imageView)
        layoutContextImageView(imageView: imageView, imageURL: user.imageURL)

        contextLabel.snp.remakeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(contextLabelRightX)
            make.leading.equalTo(contextImages.snp.trailing).offset(marginSpacing).priority(999)
        }

        switch feedContext {
        case .followingShare:
            contextString.append(name)
            contextString.append(NSAttributedString(string: " shared this episode with you"))
            break
        case .followingSubscription:
            contextString.append(name)
            contextString.append(NSAttributedString(string: " subscribed to this series"))
            break
        case .followingRecommendation:
            let imageView = ImageView(frame: CGRect(x: 0, y: 0, width: contextImagesSize, height: contextImagesSize))
            imageView.image = #imageLiteral(resourceName: "repost").imageWithInsets(insetDimen: (contextImagesSize - recastImageSize) / 2)
            contextImages.addArrangedSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.size.equalTo(contextImagesSize)
            }
            contextLabel.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.trailing.equalToSuperview().inset(contextLabelRightX)
                make.leading.equalTo(contextImages.snp.trailing).offset(smallMarginSpacing).priority(999)
            }
            contextString.append(NSAttributedString(string: "Recasted by "))
            contextString.append(name)
        default:
            break
        }
        contextLabel.attributedText = contextString
    }
    
    func setupWithSeries(series: Series) {
        contextImages.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        if series.title != "" {
            let attributedString = NSMutableAttributedString(string: series.title, attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: contextLabel.font.pointSize)])
            attributedString.append(NSAttributedString(string: " released a new episode"))
            contextLabel.attributedText = attributedString
        }

        contextLabel.snp.remakeConstraints { make in
            make.leading.equalToSuperview().inset(contextMarginX).priority(999)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(contextLabelRightX)
        }
    }

    /// for creating this view not in the feed
    func setup(with user:User) {
        contextImages.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let contextString = NSMutableAttributedString()

        let name = NSAttributedString(string: user.fullName(), attributes: [.font: UIFont.boldSystemFont(ofSize: contextLabel.font.pointSize)])

        let imageView = ImageView(frame: CGRect(x: 0, y: 0, width: contextImagesSize, height: contextImagesSize))
        contextImages.addArrangedSubview(imageView)
        layoutContextImageView(imageView: imageView, imageURL: user.imageURL)

        contextLabel.snp.remakeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(contextLabelRightX)
            make.leading.equalTo(contextImages.snp.trailing).offset(marginSpacing).priority(999)
        }

        contextString.append(name)
        contextLabel.attributedText = contextString
    }
    
    internal func layoutContextImageView(imageView: ImageView, imageURL: URL?) {
        imageView.setImageAsynchronouslyWithDefaultImage(url: imageURL)
        imageView.layer.borderWidth = 2
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.paleGrey.cgColor
        imageView.layer.cornerRadius = contextImagesSize / 2

        imageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(contextImagesSize)
        }
    }
    
    @objc func didPressFeedControlButton() {
        delegate?.didPressFeedControlButton(for: self)
    }
}
