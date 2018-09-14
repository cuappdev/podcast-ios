//
//  FeedRecastTableViewCell.swift
//  Podcast
//
//  Created by Natasha Armbrust on 5/8/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import UIKit

class FeedRecastTableViewCell: UITableViewCell, FeedElementTableViewCell {
    static let identifier: String = "FeedRecastTableViewCell"

    let supplierViewHeight: CGFloat = UserSeriesSupplierView.height

    var delegate: FeedElementTableViewCellDelegate?

    var supplierView: UIView {
        return userSeriesSupplierView
    }

    var subjectView: UIView {
        return recastSubjectView
    }

    var userSeriesSupplierView = UserSeriesSupplierView()
    var recastSubjectView = RecastSubjectView()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        initialize()
        userSeriesSupplierView.delegate = self
        recastSubjectView.delegate = self

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSupplierView))
        userSeriesSupplierView.addGestureRecognizer(tapGesture)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(context: FeedContext) {
        if case .followingRecommendation(let user, let episode) = context {
            userSeriesSupplierView.setup(with: user, for: context)
            recastSubjectView.setup(with: episode, for: user)
        }
    }

    func configure(context: FeedContext, _ isExpanded: Bool) {
        if case .followingRecommendation(let user, let episode) = context {
            userSeriesSupplierView.setup(with: user, for: context)
            recastSubjectView.setup(with: episode, for: user, isExpanded: isExpanded)
        }
    }

    @objc func didTapSupplierView() {
        delegate?.didPress(userSeriesSupplierView: userSeriesSupplierView, in: self)
    }
}

extension FeedRecastTableViewCell: RecastSubjectViewDelegate {
    func didPress(on action: EpisodeAction, for view: RecastSubjectView) {
        delegate?.didPress(on: action, for: view, in: self)
    }

    func expand(_ isExpanded: Bool) {
        delegate?.expand(isExpanded, for: self)
    }
}

extension FeedRecastTableViewCell: SupplierViewDelegate {
    func didPressFeedControlButton(for supplierView: UserSeriesSupplierView) {
        delegate?.didPressFeedControlButton(for: supplierView, in: self)
    }
}
