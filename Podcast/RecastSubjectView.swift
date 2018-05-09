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
        addSubview(recastBlurb)

        separator = UIView()
        separator.backgroundColor = .paleGrey
        addSubview(separator)

        recastBlurb.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(padding)
            make.trailing.equalToSuperview().inset(padding)
            make.top.equalToSuperview()
        }

        episodeMiniView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(padding)
            make.trailing.equalToSuperview().inset(padding)
            make.height.equalTo(96)
            make.top.equalTo(recastBlurb.snp.bottom).offset(padding)
        }

        separator.snp.makeConstraints { make in
            make.top.equalTo(episodeMiniView.snp.bottom).offset(padding)
            make.height.equalTo(separatorHeight)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    convenience init(episode: Episode) {
        self.init()
        setup(with: episode)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(with episode: Episode) {
        episodeMiniView.setup(with: episode)
        //recastBlurb.text = blurbs[EpisodeToUser(episode.id, user.id)]
    }
}

extension RecastSubjectView: EpisodeMiniSubjectViewDelegate {

    func didPress(on action: EpisodeAction) {
        delegate?.didPress(on: action, for: self)
    }
}
