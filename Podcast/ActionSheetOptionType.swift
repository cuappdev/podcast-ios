//
//  ActionSheetOptionType.swift
//  Podcast
//
//  Created by Natasha Armbrust on 3/16/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import Foundation

enum ActionSheetOptionType {
    case download(selected: Bool)
    case bookmark(selected: Bool)
    case recommend(selected: Bool)
    case listeningHistory
    case shareEpisode
    case confirmShare
    case deleteShare
    case recastDescription
    case playerSettingsTrimSilence(selected: Bool)
    case playerSettingsCustomizePlayerSettings(selected: Bool) // when we customize player settings for a series

    var title: String {
        switch (self) {
        case .download(let selected):
            return selected ? "Remove download" : "Download this episode"
        case .bookmark(let selected):
            return selected ? "Remove save" : "Save for later"
        case .recommend(let selected):
            return selected ? "Undo recast" : "Recast this episode"
        case .listeningHistory:
            return "Remove from Listening History"
        case .shareEpisode:
            return "Share this episode"
        case .confirmShare:
            return "Click to confirm share"
        case .deleteShare:
            return "Delete shared episode"
        case .recastDescription:
            return "When you recast a podcast episode, that episode is shared with your followers on their feed."
        case .playerSettingsTrimSilence:
            return "Trim silent parts of episode"
        case .playerSettingsCustomizePlayerSettings:
            return "Save player settings for all episodes of this series"
        }
    }

    var iconImage: UIImage? {
        switch(self) {
        case .download(let selected):
            return selected ? #imageLiteral(resourceName: "download_remove") : #imageLiteral(resourceName: "download")
        case .bookmark(let selected):
            return selected ? #imageLiteral(resourceName: "bookmark_feed_icon_selected") : #imageLiteral(resourceName: "bookmark_feed_icon_unselected")
        case .recommend(let selected):
            return selected ? #imageLiteral(resourceName: "repost_selected") : #imageLiteral(resourceName: "repost")
        case .listeningHistory, .deleteShare:
            return #imageLiteral(resourceName: "failure_icon")
        case .shareEpisode, .confirmShare:
            return #imageLiteral(resourceName: "iShare")
        case .recastDescription:
            return #imageLiteral(resourceName: "repost_selected")
        default:
            return nil
        }
    }

    var titleColor: UIColor {
        return .charcoalGrey
    }

    var cell: ActionSheetTableViewCellProtocol.Type {
        switch(self) {
        case .recastDescription:
            return ActionSheetRecastDescriptionTableViewCell.self
        case .playerSettingsTrimSilence, .playerSettingsCustomizePlayerSettings:
            return ActionSheetPlayerControlsTableViewCell.self
        default:
            return ActionSheetMoreOptionsStandardTableViewCell.self
        }
    }
}
