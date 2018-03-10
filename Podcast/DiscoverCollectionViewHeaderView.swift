//
//  DiscoverTableViewHeaderView.swift
//  Podcast
//
//  Created by Kevin Greer on 2/19/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit

enum DiscoverHeaderType: String {
    case topics = "Topics"
    case series = "Series"
    case episodes = "Episodes"
}

protocol DiscoverTableViewHeaderDelegate: class {
    func discoverTableViewHeaderDidPressBrowse(sender: DiscoverCollectionViewHeaderView)
}

class DiscoverCollectionViewHeaderView: UIView {
    
    let edgePadding: CGFloat = 18
    let headerHeight: CGFloat = 60
    var mainLabel: UILabel!
    var browseButton: UIButton!
    weak var delegate: DiscoverTableViewHeaderDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        mainLabel = UILabel(frame: .zero)
        mainLabel.font = ._14SemiboldFont()
        mainLabel.textColor = .charcoalGrey
        addSubview(mainLabel)
        mainLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(edgePadding)
            make.height.equalTo(headerHeight)
            make.top.equalToSuperview()
        }

        browseButton = UIButton(frame: .zero)
        browseButton.titleLabel?.font = ._12RegularFont()
        browseButton.setTitleColor(.slateGrey, for: .normal)
        browseButton.addTarget(self, action: #selector(pressBrowse), for: .touchUpInside)
        addSubview(browseButton)
        browseButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(edgePadding)
            make.height.equalTo(headerHeight)
            make.top.equalToSuperview()
        }
    }
    
    func configure(sectionType: DiscoverHeaderType) {
        mainLabel.text = "Top \(sectionType.rawValue)"

        switch sectionType {
        case .topics, .series:
            browseButton.setTitle("Browse all \(sectionType.rawValue.lowercased())", for: .normal)
        case .episodes:
            browseButton.isEnabled = false
            browseButton.isHidden = true
        }

    }

    @objc func pressBrowse() {
        delegate?.discoverTableViewHeaderDidPressBrowse(sender: self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
