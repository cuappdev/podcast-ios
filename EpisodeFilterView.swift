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

protocol EpisodeFilterDelegate {
    func filterEpisodes(filterType: FilterType)
}

class EpisodeFilterView: UIView {

    // MARK: - Variables
    var stackView: UIStackView!
    var underline: UIView!
    var divider: UIView!

    var selected: FilterType = .newest

    weak var delegate: PodcastDetailViewController?

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

        divider = UIView()
        divider.backgroundColor = .gray

        addSubview(stackView)
        addSubview(underline)
        addSubview(divider)

        setUpConstraints()
    }

    func setUpConstraints() {
        // MARK: - Constants
        let edgeInset = 22
        let dividerHeight = 0.5

        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(edgeInset)
        }

        underline.snp.makeConstraints { make in
            make.height.equalTo(underlineHeight)
            make.leading.trailing.equalTo(stackView.subviews[selected.tag()])
            make.centerY.equalTo(stackView.snp.bottom)
        }

        divider.snp.makeConstraints { make in
            make.height.equalTo(dividerHeight)
            make.leading.trailing.equalToSuperview()
            make.centerY.equalTo(underline.snp.bottom)
        }
    }

    @objc func didSelect(sender:UIButton) {
        selected = FilterType.allCases[sender.tag]
        delegate?.filterEpisodes(filterType: selected)
        UIView.animate(withDuration: 0.25) {
            self.underline.snp.remakeConstraints { make in
                make.height.equalTo(self.underlineHeight)
                make.leading.trailing.equalTo(self.stackView.subviews[self.selected.tag()])
                make.centerY.equalTo(self.stackView.snp.bottom)
            }
            self.layoutSubviews()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
