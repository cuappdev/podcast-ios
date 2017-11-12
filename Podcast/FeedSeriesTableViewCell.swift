import UIKit

class FeedSeriesTableViewCell: UITableViewCell, FeedElementTableViewCell {
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
        seriesSubjectView.delegate = self
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(context: FeedContext) {
        switch context {
        case .followingRecommendation, .newlyReleasedEpisode: break
        case let .followingSubscription(user, series):
            userSeriesSupplierView.setupWithUsers(users: [user], feedContext: context)
            seriesSubjectView.setupWithSeries(series: series)
        }
    }
}

extension FeedSeriesTableViewCell: SeriesSubjectViewDelegate {
    func seriesSubjectViewDidPressSubscribeButton(seriesSubjectView: SeriesSubjectView) {
        delegate?.didPressSubscribeButton(for: seriesSubjectView, in: self)
    }
}

