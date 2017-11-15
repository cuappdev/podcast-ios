import Foundation

extension Series {
    enum Animation: String {
        case image = "image"
        case title = "title"
        case container = "container"

        func id(series: Series) -> String {
            return series.seriesId + "_" + rawValue
        }
    }
}

extension Episode {
    enum Animation: String {
        case title = "title"
        case image = "image"
        case date = "date"
        case utilityBar = "utilityBar"
        case description = "description"

        func id(episode: Episode) -> String {
            return episode.id + "_" + rawValue
        }
    }
}
