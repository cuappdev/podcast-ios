import UIKit

class FeedEpisodeTableViewCell: UITableViewCell, FeedElementTableViewCell {
    static let identifier: String = "FeedEpisodeTableViewCell"

    let supplierViewHeight: CGFloat = UserSeriesSupplierView.height

    var delegate: FeedElementTableViewCellDelegate?

    var supplierView: UIView {
        return userSeriesSupplierView
    }

    var subjectView: UIView {
        return episodeSubjectView
    }

    var userSeriesSupplierView = UserSeriesSupplierView()
    var episodeSubjectView = EpisodeSubjectView()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        initialize()
        userSeriesSupplierView.delegate = self
        episodeSubjectView.delegate = self

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSupplierView))
        userSeriesSupplierView.addGestureRecognizer(tapGesture)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(context: FeedContext) {
        switch context {
        case let .followingRecommendation(user, episode):
            userSeriesSupplierView.setupWithUsers(users: [user], feedContext: context)
            episodeSubjectView.setup(with: episode)
        case let .newlyReleasedEpisode(series, episode):
            userSeriesSupplierView.setupWithSeries(series: series)
            episodeSubjectView.setup(with: episode)
        case let .followingShare(user, episode):
            userSeriesSupplierView.setupWithUsers(users: [user], feedContext: context)
            episodeSubjectView.setup(with: episode)
        case .followingSubscription: break
        }
    }

    @objc func didTapSupplierView() {
        delegate?.didPress(userSeriesSupplierView: userSeriesSupplierView, in: self)
    }
}

extension FeedEpisodeTableViewCell: EpisodeSubjectViewDelegate {
    func episodeSubjectViewDidPressPlayPauseButton(episodeSubjectView: EpisodeSubjectView) {
        delegate?.didPressPlayPauseButton(for: episodeSubjectView, in: self)
    }

    func episodeSubjectViewDidPressRecommendButton(episodeSubjectView: EpisodeSubjectView) {
        delegate?.didPressRecommendedButton(for: episodeSubjectView, in: self)
    }

    func episodeSubjectViewDidPressBookmarkButton(episodeSubjectView: EpisodeSubjectView) {
        delegate?.didPressBookmarkButton(for: episodeSubjectView, in: self)
    }

    func episodeSubjectViewDidPressMoreActionsButton(episodeSubjectView: EpisodeSubjectView) {
        delegate?.didPressMoreButton(for: episodeSubjectView, in: self)
    }
}

extension FeedEpisodeTableViewCell: SupplierViewDelegate {
    func didPressFeedControlButton(for supplierView: UserSeriesSupplierView) {
        delegate?.didPressFeedControlButton(for: supplierView, in: self)
    }
}
