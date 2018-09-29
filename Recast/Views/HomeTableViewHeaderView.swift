//
//  HomeTableViewHeaderView.swift
//  Recast
//
//  Created by Jaewon Sim on 9/17/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import UIKit

protocol HomeTableViewHeaderViewDelegate: class {
    func homeTableViewHeaderView(_ tableHeader: HomeTableViewHeaderView, didPress: Action)
}

/// Represents an action that can be performed on a button
enum Action {
    case seeAll
}

class HomeTableViewHeaderView: UIView {

    // MARK: View vars
    var headerTitleLabel: UILabel!
    var seeAllButton: UIButton!

    // MARK: Delegate
    weak var delegate: HomeTableViewHeaderViewDelegate?

    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)

        headerTitleLabel = UILabel()
        headerTitleLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        headerTitleLabel.textColor = .white
        addSubview(headerTitleLabel)

        seeAllButton = UIButton(type: .system)
        seeAllButton.setTitle("See all", for: .normal)
        seeAllButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        seeAllButton.setTitleColor(.white, for: .normal)
        seeAllButton.isEnabled = true
        seeAllButton.addTarget(self, action: #selector(didPressSeeAll), for: .touchUpInside)
        addSubview(seeAllButton)

        setUpConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Constraint setup
    func setUpConstraints() {
        // MARK: Constraint constants
        let sidePadding: CGFloat = 22
        let bottomPadding: CGFloat = 12
        let seeAllButtonWidth: CGFloat = 40

        headerTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(sidePadding)
            make.bottom.equalToSuperview().offset(-bottomPadding)
        }

        seeAllButton.snp.makeConstraints { make in
            make.centerY.equalTo(headerTitleLabel)
            make.trailing.equalToSuperview().inset(sidePadding)
            make.height.equalTo(headerTitleLabel.snp.height)
            make.width.equalTo(seeAllButtonWidth)
        }
    }

    func configure(for sectionType: HomeSectionType) {
        headerTitleLabel.text = sectionType.rawValue
        switch sectionType {
        case .continueListening:
            seeAllButton.isHidden = true
        case .yourFavorites:
            seeAllButton.isHidden = false
        case .browseTopics:
            seeAllButton.isHidden = false
        }
    }

    @objc func didPressSeeAll() {
        delegate?.homeTableViewHeaderView(self, didPress: .seeAll)
    }
}
