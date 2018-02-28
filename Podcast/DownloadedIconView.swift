//
//  DownloadedIconView.swift
//  Podcast
//
//  Created by Drew Dunne on 2/28/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit

class DownloadedIconView: UIView {
    
    static let viewWidth: CGFloat = 95
    
    let iconLabelPadding: CGFloat = 7
    let iconSize: CGFloat = 12
    
    var downloadedIcon: ImageView!
    var downloadedLabel: UILabel!
    
    convenience init() {
        self.init(frame: .zero)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        
        downloadedIcon = ImageView(image: #imageLiteral(resourceName: "downloaded"))
        
        downloadedLabel = UILabel()
        downloadedLabel.font = .systemFont(ofSize: 12)
        downloadedLabel.textColor = UIColor.slateGrey
        downloadedLabel.text = "Downloaded"
        
        addSubview(downloadedIcon)
        addSubview(downloadedLabel)
        
        downloadedIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalTo(iconSize)
            make.height.equalTo(iconSize)
        }
        
        downloadedLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(downloadedIcon.snp.trailing).offset(iconLabelPadding)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.greaterThanOrEqualTo(DownloadedIconView.viewWidth - iconSize - iconLabelPadding)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
