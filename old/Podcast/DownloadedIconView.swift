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
        downloadedLabel.font = ._12RegularFont()
        downloadedLabel.textColor = .slateGrey
        downloadedLabel.text = "Downloaded"
        
        addSubview(downloadedIcon)
        addSubview(downloadedLabel)
        
        downloadedIcon.snp.makeConstraints { make in
            make.centerY.leading.equalToSuperview()
            make.width.height.equalTo(iconSize)
        }
        
        downloadedLabel.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setup(_ downloadStatus: DownloadStatus) {
        switch downloadStatus {
        case .finished:
            downloadedIcon.isHidden = false
            downloadedLabel.isHidden = false
            downloadedLabel.text = "Downloaded"
            downloadedLabel.snp.remakeConstraints { make in
                make.top.trailing.bottom.equalToSuperview()
                make.leading.equalTo(downloadedIcon.snp.trailing).offset(iconLabelPadding)
            }
        case .waiting:
            downloadedIcon.isHidden = true
            downloadedLabel.isHidden = false
            downloadedLabel.text = "Downloading"
            downloadedLabel.snp.remakeConstraints { make in
                make.top.leading.trailing.bottom.equalToSuperview()
            }
        default:
            downloadedIcon.isHidden = true
            downloadedLabel.isHidden = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
