//
//  EpisodeFilterView.swift
//  Recast
//
//  Created by Jack Thompson on 10/25/18.
//  Copyright © 2018 Cornell AppDev. All rights reserved.
//

import UIKit

enum FilterType: String, CaseIterable {
    case newest = "Newest"
    case oldest = "Oldest"
    case popular = "Popular"
    case unlistened = "Unlistened"

    func tag() -> (Int) {
        switch self {
        case .newest: return 0
        case .oldest: return 1
        case .popular: return 2
        case .unlistened: return 3
        }
    }
}

class EpisodeFilterView: UIView {

    // MARK: - Variables
    var stackView: UIStackView!
    var underline: UIView!

    var selected: FilterType = .newest

    // MARK: - Constants
    let underlineHeight = 2.5

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black

        stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing

        for filter in FilterType.allCases {
            let button = UIButton()
            button.tag = filter.tag()
            button.setTitle(filter.rawValue, for: .normal)
            button.addTarget(self, action: #selector(didSelect), for: .touchUpInside)
            stackView.addArrangedSubview(button)
        }

        underline = UIView()
        underline.backgroundColor = .white
        underline.setCornerRadius(forView: .small)

        addSubview(stackView)
        addSubview(underline)

        setUpConstraints()
    }

    func setUpConstraints() {
        // MARK: - Constants
        let edgeInset = 22

        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(edgeInset)
        }

        underline.snp.makeConstraints { make in
            make.height.equalTo(underlineHeight)
            make.leading.trailing.equalTo(stackView.subviews[selected.tag()])
            make.top.equalTo(stackView.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }

    @objc func didSelect(sender:UIButton) {
        selected = FilterType.allCases[sender.tag]
        UIView.animate(withDuration: 0.25) {
            self.underline.snp.remakeConstraints { make in
                make.height.equalTo(self.underlineHeight)
                make.leading.trailing.equalTo(self.stackView.subviews[self.selected.tag()])
                make.top.equalTo(self.stackView.snp.bottom)
                make.bottom.equalToSuperview()
            }
            self.layoutSubviews()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
