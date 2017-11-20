//
//  DiscoverTableViewHeaderView.swift
//  Podcast
//
//  Created by Kevin Greer on 2/19/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

protocol DiscoverTableViewHeaderDelegate: class {
    func discoverTableViewHeaderDidPressBrowse()
}

class DiscoverTableViewHeader: UIView {
    
    let edgePadding: CGFloat = 18
    let widthMultiplier: CGFloat = 0.75
    var mainLabel: UILabel!
    var browseButton: UIButton!
    var delegate: DiscoverTableViewHeaderDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        mainLabel = UILabel(frame: .zero)
        mainLabel.font = ._14SemiboldFont()
        mainLabel.textColor = .charcoalGrey
        addSubview(mainLabel)
        mainLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(edgePadding)
            make.width.equalToSuperview().multipliedBy(widthMultiplier)
            make.height.equalToSuperview()
        }

        browseButton = UIButton(frame: .zero)
        browseButton.titleLabel?.font = ._12RegularFont()
        browseButton.setTitleColor(.slateGrey, for: .normal)
        browseButton.addTarget(self, action: #selector(pressBrowse), for: .touchUpInside)
        addSubview(browseButton)
        browseButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(edgePadding)
            make.height.equalToSuperview()
        }
    }
    
    func configure(sectionName: String) {
        mainLabel.text = "Top \(sectionName)"
        browseButton.setTitle("Browse all \(sectionName.lowercased())", for: .normal)
    }

    @objc func pressBrowse() {
        delegate?.discoverTableViewHeaderDidPressBrowse()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
