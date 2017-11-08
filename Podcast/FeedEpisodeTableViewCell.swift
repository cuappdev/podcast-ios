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
        episodeSubjectView.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(context: FeedContext) {
        switch context {
        case let .followingRecommendation(user, episode):
            userSeriesSupplierView.setupWithUsers(users: [user], feedContext: context)
            episodeSubjectView.setupWithEpisode(episode: episode)
            
        case let .newlyReleasedEpisode(series, episode):
            userSeriesSupplierView.setupWithSeries(series: series)
            episodeSubjectView.setupWithEpisode(episode: episode)
        case .followingSubscription: break
        }
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

    func episodeSubjectViewDidPressTagButton(episodeSubjectView: EpisodeSubjectView, index: Int) {
        delegate?.didPressTagButton(for: episodeSubjectView, in: self, index: index)
    }

    func episodeSubjectViewDidPressMoreActionsButton(episodeSubjectView: EpisodeSubjectView) {
        delegate?.didPressMoreButton(for: episodeSubjectView, in: self)
    }


}
