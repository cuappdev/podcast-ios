import Foundation

extension Series {
    enum Animation: String {
        case image = "image"
        case detailTitle = "detailTitle"
        case cellTitle = "title"
        case container = "container"
        case subscribe = "subscribe"

        func id(series: Series) -> String {
            return series.seriesId + "_" + rawValue
        }
    }
}

extension Episode {
    enum Animation: String {
        case detailTitle = "detailTitle"
        case cellTitle = "title"
        case image = "image"
        case detailDate = "detailDate"
        case cellDate = "date"
        case container = "container"

        func id(episode: Episode) -> String {
            return episode.id + "_" + rawValue
        }
    }
}
