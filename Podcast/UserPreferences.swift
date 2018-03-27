//
//  UserPreferences.swift
//  Podcast
//
//  Created by Natasha Armbrust on 3/20/18.
//  Copyright © 2018 Cornell App Development. All rights reserved.
//

import Foundation

class SeriesPreferences: NSObject, NSCoding {
    var playerRate: PlayerRate
    var trimSilences: Bool //TODO

    struct Keys {
        static let rate = "rate"
        static let trimSilence = "trim_silence"
    }

    convenience init?(data: Data) {
        if let prefs = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as? SeriesPreferences {
            self.init(playerRate: prefs.playerRate, trimSilences: prefs.trimSilences)
        }
        return nil
    }

    override convenience init() {
        self.init(playerRate: .one, trimSilences: false)
    }

    init(playerRate: PlayerRate, trimSilences: Bool) {
        self.playerRate = playerRate
        self.trimSilences = trimSilences
    }

    required convenience init(coder decoder: NSCoder) {
        self.init()
        self.playerRate = PlayerRate(rawValue: decoder.decodeFloat(forKey: Keys.rate)) ?? .one
        self.trimSilences = decoder.decodeBool(forKey: Keys.trimSilence)
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(playerRate.rawValue, forKey: Keys.rate)
        aCoder.encode(trimSilences, forKey: Keys.trimSilence)
    }
}

class UserPreferences {

    static let key: String = "user-prefs"
    static let defaultPlayerRateKey: String = "default-player-rate"

    // userId: [seriesId: prefs] -> may have more than one user due to logging out ability
    static var userPreferences: [String: [String: SeriesPreferences]] {
        get {
            if let savedData = UserDefaults.standard.value(forKey: UserPreferences.key) as? Data, let savedPrefs = NSKeyedUnarchiver.unarchiveObject(with: savedData) {
                return (savedPrefs as? [String: [String: SeriesPreferences]]) ?? [:]
            } else { // nothing saved yet
                let prefs: [String: [String: SeriesPreferences]] = [:]
                let prefsData = NSKeyedArchiver.archivedData(withRootObject: prefs)
                UserDefaults.standard.set(prefsData, forKey: UserPreferences.key)
                return prefs
            }
        }
    }

    static func userToSeriesPreference(for user: User, seriesId: String) -> SeriesPreferences? {
        guard let usersPrefs = UserPreferences.userPreferences[user.id], let seriesPrefs = usersPrefs[seriesId] else { return nil }
        return seriesPrefs
    }

    static func savePreference(preference: SeriesPreferences, for user: User, and seriesId: String) {
        var currentPreferences = self.userPreferences
        if var userPrefs = currentPreferences[user.id] { // this user exists in preferences saved
            userPrefs[seriesId] = preference
            currentPreferences[user.id] = userPrefs
        } else {
            currentPreferences[user.id] = [seriesId: preference]
        }
        let prefsData = NSKeyedArchiver.archivedData(withRootObject: currentPreferences)
        UserDefaults.standard.set(prefsData, forKey: UserPreferences.key)
    }

    static func removePreference(for user: User, and seriesId: String) {
        var currentPreferences = self.userPreferences
        if var userPrefs = currentPreferences[user.id] { // this user exists in preferences saved
            userPrefs.removeValue(forKey: seriesId)
            currentPreferences[user.id] = userPrefs
        }
        let prefsData = NSKeyedArchiver.archivedData(withRootObject: currentPreferences)
        UserDefaults.standard.set(prefsData, forKey: UserPreferences.key)
    }

    static var defaultPlayerRate: PlayerRate {
        get {
            if let rate = PlayerRate(rawValue: UserDefaults.standard.float(forKey: UserPreferences.defaultPlayerRateKey)) {
                return rate
            } else { // nothing saved yet
                saveDefaultPlayerRate(rate: .one)
                return .one
            }
        }
    }

    static func saveDefaultPlayerRate(rate: PlayerRate) {
        UserDefaults.standard.set(rate.rawValue, forKey: UserPreferences.defaultPlayerRateKey)
    }
}
