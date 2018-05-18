//
//  RecastSubjectView.swift
//  Podcast
//
//  Created by Natasha Armbrust on 5/8/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit

protocol RecastSubjectViewDelegate: class {
    func didPress(on action: EpisodeAction, for view: RecastSubjectView)
    func expand(_ isExpanded: Bool)
}

class RecastSubjectView: UIView {

    ///
    /// Mark: View Constants
    ///
    let padding: CGFloat = 18
    let separatorHeight: CGFloat = 9

    ///
    /// Mark: Variables
    ///
    var recastBlurb: UILabel!
    var episodeMiniView: EpisodeMiniSubjectView!
    var separator: UIView!
    var currentlyExpanded: Bool = false

    var expandedText: NSMutableAttributedString!

    weak var delegate: RecastSubjectViewDelegate?
    
    ///
    ///Mark: Init
    ///
    init() {
        super.init(frame: .zero)
        backgroundColor = .offWhite

        episodeMiniView = EpisodeMiniSubjectView()
        episodeMiniView.delegate = self
        addSubview(episodeMiniView)

        recastBlurb = UILabel()
        recastBlurb.textColor = .charcoalGrey
        recastBlurb.font = ._14RegularFont()
        recastBlurb.numberOfLines = 3
        recastBlurb.isUserInteractionEnabled = true
        recastBlurb.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(readPress)))
        addSubview(recastBlurb)

        separator = UIView()
        separator.backgroundColor = .paleGrey
        addSubview(separator)

        recastBlurb.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(padding)
            make.trailing.equalToSuperview().inset(padding)
            make.top.equalToSuperview().inset(padding)
        }

        episodeMiniView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(padding)
            make.trailing.equalToSuperview().inset(padding)
            make.top.equalTo(recastBlurb.snp.bottom).offset(padding)
        }

        separator.snp.makeConstraints { make in
            make.top.equalTo(episodeMiniView.snp.bottom).offset(padding)
            make.height.equalTo(separatorHeight)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(with episode: Episode, for user: User, isExpanded: Bool = false) {
        recastBlurb.numberOfLines = 3
        episodeMiniView.setup(with: episode)
        let recastText = UserEpisodeData.shared.getBlurb(for: EpisodeToUser(episodeID: episode.id, userID: user.id)) ?? ""
        recastBlurb.text = recastText
        expandedText = NSMutableAttributedString(string: recastText, attributes: [.font: UIFont._14RegularFont()])
        expandedText.append(NSMutableAttributedString(string: " Read Less", attributes: [.font: UIFont._14RegularFont(), .foregroundColor: UIColor.sea]))
        expand(isExpanded)
        if recastText == "" {
            episodeMiniView.snp.remakeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(padding)
                make.top.equalTo(recastBlurb.snp.bottom)
            }
        } else {
            episodeMiniView.snp.remakeConstraints { make in
                make.leading.trailing.equalToSuperview().inset(padding)
                make.top.equalTo(recastBlurb.snp.bottom).offset(padding)
            }
        }
    }

    @objc func readPress() {
        expand(!currentlyExpanded)
        delegate?.expand(currentlyExpanded)
    }

    func expand(_ isExpanded: Bool) {
        currentlyExpanded = isExpanded
        if currentlyExpanded && recastBlurb.numberOfVisibleLines >= 3 {
            recastBlurb.numberOfLines = 0
            recastBlurb.attributedText = expandedText
        } else {
            DispatchQueue.main.async {
                self.recastBlurb.attributedText = UILabel.addTrailing(to: self.recastBlurb, with: "... ", moreText: "Read More", moreTextFont: ._14RegularFont(), moreTextColor: .sea, numberOfLinesAllowed: 3)
            }
        }
    }
}

extension RecastSubjectView: EpisodeMiniSubjectViewDelegate {

    func didPress(on action: EpisodeAction) {
        delegate?.didPress(on: action, for: self)
    }
}
