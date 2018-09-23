//
//  HomeTableViewHeaderView.swift
//  Recast
//
//  Created by Jaewon Sim on 9/17/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import UIKit

enum HomeSectionType: String {
    case continueListening = "Continue Listening"
    case yourFavorites = "Your Favorites"
    case browseTopics = "Browse Topics"
}

protocol HomeTableViewHeaderViewDelegate: class {
    func homeTableViewHeaderDidPressSeeAll(sender: HomeTableViewHeaderView)
}

class HomeTableViewHeaderView: UIView {

    var headerTitleLabel: UILabel!
    var seeAllButton: UIButton!
    weak var delegate: HomeTableViewHeaderViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        headerTitleLabel = UILabel(frame: .zero)
        headerTitleLabel.font = UIFont.boldSystemFont(ofSize: 22)
        headerTitleLabel.textColor = .white
        addSubview(headerTitleLabel)

        seeAllButton = UIButton(frame: .zero)
        seeAllButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        seeAllButton.setTitleColor(.lightGray, for: .normal)
        seeAllButton.isEnabled = true
        seeAllButton.addTarget(self, action: #selector(didPressSeeAll), for: .touchUpInside)
        addSubview(seeAllButton)

        setUpConstraints()
    }

    func setUpConstraints() {
        let sidePadding: CGFloat = 18
        let bottomPadding: CGFloat = 12

        headerTitleLabel.snp.makeConstraints { (make) -> Void in
            make.leading.equalToSuperview().offset(12)
            make.bottom.equalToSuperview().offset(-bottomPadding)
        }

        seeAllButton.snp.makeConstraints { make in
            make.top.equalTo(headerTitleLabel.snp.top)
            make.trailing.equalToSuperview().inset(sidePadding)
            make.height.equalTo(headerTitleLabel.snp.height)
        }
    }

    func configure(for sectionType: HomeSectionType) {
        switch sectionType {
        case .continueListening:
            seeAllButton.isHidden = true
            headerTitleLabel.text = sectionType.rawValue
        case .yourFavorites:
            seeAllButton.isHidden = false
            headerTitleLabel.text = sectionType.rawValue
        case .browseTopics:
            seeAllButton.isHidden = false
            headerTitleLabel.text = sectionType.rawValue
        }
    }

    @objc func didPressSeeAll() {
        delegate?.homeTableViewHeaderDidPressSeeAll(sender: self)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
