//
//  ProfileActivityTableViewCell.swift
//  Podcast
//
//  Created by Drew Dunne on 10/10/16.
//  Copyright © 2016 Cornell App Development. All rights reserved.
//

import UIKit

class ProfileActivityTableViewCell: UITableViewCell {
    
    let height: CGFloat = 70
    let contentPaddingX:CGFloat = 6.0
    let contentPaddingY:CGFloat = 3.0
    
    var actLabel: UILabel!
    var dateLabel: UILabel!
    var containerView: UIView!
    var podImage: UIImageView!
    
    var activity: UserActivity? {
        didSet {
            if let activity = activity {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "eee, MMM dd"
//                dateFormatter.timeStyle = .none
                
                dateFormatter.locale = Locale(identifier: "en_US")
                dateLabel.text = dateFormatter.string(from: activity.date as Date)
//                print(dateFormatter.string(from: activity.date as Date))
                
                // Check for image
                podImage.image = activity.episode.smallArtworkImage
                
//                let podcastName = NSAttributedString(string: activity.episode.title, attributes: [NSForegroundColorAttributeName: UIColor.podcastPinkText, NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
//                let seriesName = NSAttributedString(string: (activity.episode.series?.publisher?.name)!, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
//                let authorName = NSAttributedString(string: activity.episode.title, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
                let podcastName = activity.episode.title
//                let seriesName = (activity.episode.series?.title)!
//                let authorName = (activity.episode.series?.publisher?.name)!
                var actText = NSMutableAttributedString()
                switch (activity.action) {
                case .Liked:
                    actText = NSMutableAttributedString(string: "Liked "+podcastName)
                    actText.addAttributes([NSForegroundColorAttributeName: UIColor.podcastPink, NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)], range: NSRange(location: 6, length:podcastName.characters.count))
//                    actText.addAttributes([NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)], range: NSRange(location: 6+podcastName.characters.count+4, length:seriesName.characters.count))
                    break
                case .Listened:
                    actText = NSMutableAttributedString(string: "Listened to "+podcastName)
                    actText.addAttributes([NSForegroundColorAttributeName: UIColor.podcastPink, NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)], range: NSRange(location: 12, length:podcastName.characters.count))
//                    actText.addAttributes([NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)], range: NSRange(location: 12+podcastName.characters.count+4, length:seriesName.characters.count))
                    break
                }
                actLabel.attributedText = actText
            }
        }
    }
    
    // Mark: Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        frame.size.height = height+2*contentPaddingY
        backgroundColor = UIColor.podcastWhite
        selectionStyle = .none
        
        containerView = UIView(frame: CGRect.zero)
        containerView.backgroundColor = UIColor.podcastWhiteDark
        contentView.addSubview(containerView)
        
        podImage = UIImageView(frame: CGRect.zero)
        podImage.image = #imageLiteral(resourceName: "fillerImage")
        containerView.addSubview(podImage)
        
        actLabel = UILabel(frame: CGRect.zero)
        actLabel.textAlignment = .left
        actLabel.font = UIFont.systemFont(ofSize: 14)
        actLabel.textColor = UIColor.black
        actLabel.numberOfLines = 1
//        actLabel.backgroundColor = .red
        containerView.addSubview(actLabel)
        
        dateLabel = UILabel(frame: CGRect.zero)
        dateLabel.textAlignment = .left
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.textColor = UIColor.darkGray
//        dateLabel.backgroundColor = .green
        containerView.addSubview(dateLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        let cellSize = self.frame.size
        containerView.frame = CGRect(x: contentPaddingX, y: contentPaddingY, width: cellSize.width-2*contentPaddingX, height: height)
        
        let containSize = containerView.frame.size
        let cellPadding:CGFloat = 12.0
        let spacing:CGFloat = 12.0
        let dateLabelHeight:CGFloat = 15.0
        
        let imageHeight:CGFloat = (height-2*cellPadding)
        let labelWidth:CGFloat = containSize.width - 2*cellPadding - imageHeight - spacing
        let labelHeight:CGFloat = 17
        podImage.frame = CGRect(x: cellPadding, y: cellPadding, width: imageHeight, height: imageHeight)
        actLabel.frame = CGRect(x: cellPadding+imageHeight+spacing, y: 1.5*cellPadding, width: labelWidth, height: labelHeight)
        dateLabel.frame = CGRect(x: cellPadding+imageHeight+spacing, y: 1.5*cellPadding+labelHeight+3, width: labelWidth, height: dateLabelHeight)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        containerView.backgroundColor = selected ? UIColor.podcastGray : UIColor.podcastWhiteDark
    }

}
