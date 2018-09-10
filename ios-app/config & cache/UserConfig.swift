//
//  UserConfig.swift
//  Hausa
//
//  Created by Emre Can Bolat on 16.12.17.
//  Copyright © 2017 MNM Team. All rights reserved.
//

import Foundation
import UIKit

enum FilterType: Int, Codable {
    case hausa, english, both
}

class UserConfig: Config {

    static var clientActivated = false
    
    static var quality: String = "mi"
    static var databaseTimestamp: Int64 = 332145240
    static var updateOnlyOnWifi: Bool = true
    static var participateInStats: Bool = false
    static var updateStatsOnStartup: Bool = false
    
    static var checkForUpdatesOnStartup: Bool = false
    
    static var recentSearches: [Entry] = []
    static var searchFilter: FilterType = .both
    
    static var mainThemeColor: Int = 0x295b2f
    static var mostPopularColor: Int = 0x295b2f
    static var recentSearchesColor: Int = 0x295b2f
    static var recentViewsColor: Int = 0x295b2f
    
    static func save(_ alone: Bool? = false) {
        preferences.set(quality, forKey: "quality")
        preferences.set(databaseTimestamp, forKey: "databaseTimestamp")
        preferences.set(updateOnlyOnWifi, forKey: "updateOnlyOnWifi")
        preferences.set(participateInStats, forKey: "participateInStats")
        preferences.set(updateStatsOnStartup, forKey: "updateStatsOnStartup")
        preferences.set(NSKeyedArchiver.archivedData(withRootObject: recentSearches), forKey: "recentSearches")
        preferences.set(searchFilter.hashValue, forKey: "searchFilter")
        preferences.set(mainThemeColor.hashValue, forKey: "mainThemeColor")
        preferences.set(mostPopularColor.hashValue, forKey: "mostPopularColor")
        preferences.set(recentSearchesColor.hashValue, forKey: "recentSearchesColor")
        preferences.set(recentViewsColor.hashValue, forKey: "recentViewsColor")
        preferences.set(checkForUpdatesOnStartup.hashValue, forKey: "checkForUpdatesOnStartup")
        
        if alone! { preferences.synchronize() }
    }
    
    static func readConfig() {
        if preferences.object(forKey: "databaseTimestamp") != nil {
            self.clientActivated = true
            
            self.quality = preferences.string(forKey: "quality")!
            
            self.databaseTimestamp = preferences.object(forKey: "databaseTimestamp") as! Int64
            self.updateOnlyOnWifi = preferences.bool(forKey: "updateOnlyOnWifi")
            self.participateInStats = preferences.bool(forKey: "participateInStats")
            self.updateStatsOnStartup = preferences.bool(forKey: "updateStatsOnStartup")
            self.searchFilter = FilterType(rawValue: preferences.integer(forKey: "searchFilter"))!
            if let recentSearchesObject = preferences.value(forKey: "recentSearches") as? NSData {
                recentSearches = NSKeyedUnarchiver.unarchiveObject(with: recentSearchesObject as Data) as! [Entry]
            }
            self.mainThemeColor = preferences.integer(forKey: "mainThemeColor")
            self.mostPopularColor = preferences.integer(forKey: "mostPopularColor")
            self.recentSearchesColor = preferences.integer(forKey: "recentSearchesColor")
            self.recentViewsColor = preferences.integer(forKey: "recentViewsColor")
            self.checkForUpdatesOnStartup = preferences.bool(forKey: "checkForUpdatesOnStartup")
        } else {
            self.clientActivated = false
        }
    }
    
    static func getImageQuality() -> String {
        return quality
    }
    
    static func setImageQuality(quality: String) {
        self.quality = quality
    }
    
    static func getDatabaseTimestamp() -> Int64 {
        return databaseTimestamp
    }
    
    static func setDatabaseTimestamp(timestamp: Int64) {
        self.databaseTimestamp = timestamp
    }
    
    static func isUpdateOnlyOnWifi() -> Bool {
        return updateOnlyOnWifi
    }
    
    static func setUpdateOnlyOnWifi(onlyWifi: Bool) {
        self.updateOnlyOnWifi = onlyWifi
    }
    
    static func isParticipatingInStats() -> Bool {
        return participateInStats
    }
    
    static func setParticipateInStats(participate: Bool) {
        self.participateInStats = participate
    }
    
    static func isUpdatingStatsOnStartup() -> Bool {
        return updateStatsOnStartup
    }
    
    static func setUpdatingStatsOnStartup(onStartup: Bool) {
        self.updateStatsOnStartup = onStartup
    }
    
    static func isClientActivated() -> Bool {
        return clientActivated
    }
    
    static func getRecentSearches() -> [Entry] {
        return recentSearches
    }
    
    static func getRecentSearches(_ limit: Int) -> [Entry] {
        var lim = limit
        if recentSearches.count < limit { lim = recentSearches.count }
        if recentSearches.count == 0 { return [] }
        return Array(recentSearches[0...lim-1])
    }
    
    static func getRecentSearchesAt(_ from: Int, _ to: Int) -> [SignImage]? {
        var entries: [SignImage] = []
        
        for (index, word) in recentSearches.enumerated() {
            if index < from { continue }
            entries.append(word.imageList.first!)
            if index == to { break }
        }
        return entries
    }
    
    static func addSearchEntry(entry: Entry) {
        for (index, word) in recentSearches.enumerated() {
            if word.id == entry.id {
                recentSearches.remove(at: index)
                break
            }
        }
        
        recentSearches.insert(entry, at: 0)
    }
    
    static func deleteSearchEntry(pos: Int) {
        recentSearches.remove(at: pos)
    }
    
    static func getFilterType() -> FilterType {
        return searchFilter
    }
    
    static func setFilterType(type: FilterType) {
        self.searchFilter = type
    }
    
    static func isFilterType(type: FilterType) -> Bool {
        if self.searchFilter == type { return true }
        return false
    }
    
    static func setMainThemeColor(colorHex: Int) {
        self.mainThemeColor = colorHex
    }
    
    static func getMainThemeColor() -> Int {
        return mainThemeColor
    }
    
    static func setMostPopularColor(colorHex: Int) {
        self.mostPopularColor = colorHex
    }
    
    static func getMostPopularColor() -> Int {
        return mostPopularColor
    }
    
    static func setRecentSearchesColor(colorHex: Int) {
        self.recentSearchesColor = colorHex
    }
    
    static func getRecentSearchesColor() -> Int {
        return recentSearchesColor
    }
    
    static func setRecentViewsColor(colorHex: Int) {
        self.recentViewsColor = colorHex
    }
    
    static func getRecentViewsColor() -> Int {
        return recentViewsColor
    }
    
    static func isCheckForUpdatesOnStartup() -> Bool {
        return checkForUpdatesOnStartup
    }
    
    static func setCheckForUpdatesOnStartup(check: Bool) {
        self.checkForUpdatesOnStartup = check
    }
    
}
