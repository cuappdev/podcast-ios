//
//  FeedElementTableViewCell.swift
//  Podcast
//
//  Created by Natasha Armbrust on 10/7/17.
//  Copyright © 2017 Cornell App Development. All rights reserved.
//

import UIKit
import SnapKit

protocol FeedElementTableViewCellDelegate: class {
    func didPress(on action: EpisodeAction, for episodeSubjectView: EpisodeSubjectView, in cell: UITableViewCell)
    func didPress(on action: EpisodeAction, for view: RecastSubjectView, in cell: UITableViewCell)
    func didPress(userSeriesSupplierView: UserSeriesSupplierView, in cell: UITableViewCell)
    func didPressFeedControlButton(for userSeriesSubjectView: UserSeriesSupplierView, in cell: UITableViewCell)
    func didPress(on action: SeriesAction, for seriesSubjectView: SeriesSubjectView, in cell: UITableViewCell)
    func expand(_ isExanded: Bool, for cell: FeedElementTableViewCell)
}

protocol FeedElementTableViewCell {
    static var identifier: String { get }

    var supplierView: UIView { get }
    var subjectView: UIView { get }
    
    var supplierViewHeight: CGFloat { get }

    var delegate: FeedElementTableViewCellDelegate? { get set }

    func configure(context: FeedContext)
}

extension FeedElementTableViewCell where Self: UITableViewCell {
    func initialize() {
        selectionStyle = .none

        contentView.addSubview(supplierView)
        contentView.addSubview(subjectView)

        supplierView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(supplierViewHeight).priority(999) // should make this generic
        }

        subjectView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(supplierView.snp.bottom)
            make.bottom.equalToSuperview()
        }
    }
}

extension UITableView {
    fileprivate var feedElementTableViewCells: [(UITableViewCell & FeedElementTableViewCell).Type] {
        return [FeedEpisodeTableViewCell.self, FeedSeriesTableViewCell.self, FeedRecastTableViewCell.self]
    }

    func registerFeedElementTableViewCells() {
        feedElementTableViewCells.forEach { register($0, forCellReuseIdentifier: $0.identifier) }
    }
}
