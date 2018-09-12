import UIKit

class FeedSeriesTableViewCell: SeriesDisplayTableViewCell, FeedElementTableViewCell {
    static let identifier: String = "FeedSeriesTableViewCell"

    let supplierViewHeight: CGFloat = UserSeriesSupplierView.height

    var delegate: FeedElementTableViewCellDelegate?

    var supplierView: UIView {
        return userSeriesSupplierView
    }

    var subjectView: UIView {
        return seriesSubjectView
    }

    var userSeriesSupplierView = UserSeriesSupplierView()
    var seriesSubjectView = SeriesSubjectView()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
        userSeriesSupplierView.delegate = self
        seriesSubjectView.delegate = self
        displayView = seriesSubjectView

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapSupplierView))
        userSeriesSupplierView.addGestureRecognizer(tapGesture)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(context: FeedContext) {
        switch context {
        case .followingRecommendation, .newlyReleasedEpisode, .followingShare: break
        case let .followingSubscription(user, series):
            userSeriesSupplierView.setup(with: user, for: context)
            displayView.set(title: series.title)
            displayView.set(topicsString: series.topicString)
            displayView.set(lastUpdated: series.lastUpdatedString)
            displayView.set(numberOfSubscribers: series.numberOfSubscribers, isSubscribed: series.isSubscribed)
            if let url = series.largeArtworkImageURL {
                displayView.set(largeImageUrl: url)
            }
        }
    }

    @objc func didTapSupplierView() {
        delegate?.didPress(userSeriesSupplierView: userSeriesSupplierView, in: self)
    }
}

extension FeedSeriesTableViewCell: SeriesSubjectViewDelegate, SupplierViewDelegate {

    func didPress(on action: SeriesAction, for view: SeriesSubjectView) {
        delegate?.didPress(on: action, for: view, in: self)
    }

    func didPressFeedControlButton(for supplierView: UserSeriesSupplierView) {
        delegate?.didPressFeedControlButton(for: supplierView, in: self)
    }
}
