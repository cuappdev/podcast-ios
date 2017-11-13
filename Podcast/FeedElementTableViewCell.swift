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
    func didPressMoreButton(for episodeSubjectView: EpisodeSubjectView, in cell: UITableViewCell)
    func didPressPlayPauseButton(for episodeSubjectView: EpisodeSubjectView, in cell: UITableViewCell)
    func didPressBookmarkButton(for episodeSubjectView: EpisodeSubjectView, in cell: UITableViewCell)
    func didPressTagButton(for episodeSubjectView: EpisodeSubjectView, in cell: UITableViewCell, index: Int)
    func didPressRecommendedButton(for episodeSubjectView: EpisodeSubjectView, in cell: UITableViewCell)
    func didPressFeedControlButton(for userSeriesSubjectView: UserSeriesSupplierView, in cell: UITableViewCell)
    func didPressSubscribeButton(for seriesSubjectView: SeriesSubjectView, in cell: UITableViewCell)
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
        return [FeedEpisodeTableViewCell.self, FeedSeriesTableViewCell.self]
    }

    func registerFeedElementTableViewCells() {
        feedElementTableViewCells.forEach { register($0, forCellReuseIdentifier: $0.identifier) }
    }

    func dequeueFeedElementTableViewCell(with context: FeedContext, delegate: FeedElementTableViewCellDelegate) -> UITableViewCell & FeedElementTableViewCell {
        var cell = dequeueReusableCell(withIdentifier: context.cellType.identifier) as! UITableViewCell & FeedElementTableViewCell
        cell.configure(context: context)
        cell.delegate = delegate
        return cell
    }
}
