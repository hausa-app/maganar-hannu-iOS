//
//  StatisticsManager.swift
//  Hausa
//
//  Created by Emre Can Bolat on 23.12.17.
//  Copyright © 2017 MNM Team. All rights reserved.
//

import Foundation

class StatisticsManager {
    
    var database: LimitedDatabase
    
    init(database: LimitedDatabase) {
        self.database = database
    }
    
    func getFavoriteEntries(_ limit: Int? = nil) -> [Entry] {
        return sortList(entries: database.getFavoriteList(limit)!)
    }
    
    func getMostPopularEntries(_ limit: Int? = nil) -> [Entry] {
        return database.getMostPopularEntries(limit)!
    }
    
    func getRecentViewedEntries(_ limit: Int? = nil) -> [Entry] {
        return database.getRecentViewedEntries(limit)!
    }
    
    func getMostPopularEntriesAt(_ from: Int, _ to: Int) -> [SignImage]? {
        return database.getMostPopularEntriesAt(from, to)
    }
    
    func getRecentViewedEntriesAt(_ from: Int, _ to: Int) -> [SignImage]? {
        return database.getRecentViewedEntriesAt(from, to)
    }
    
    func updateViewed(entry: Entry) {
        self.database.updateViewed(entry: entry)
    }
    
    func removeViewed(entry: Entry) {
        self.database.removeViewed(entry: entry)
    }
    
    func changeFavoriteStatus(entry: Entry) {
        self.database.changeFavoriteStatus(entry: entry)
        entry.favorite = !entry.favorite
    }
    
    func sortList(entries: [Entry]) -> [Entry] {
        
        let sorted = entries.sorted { (object1, object2) -> Bool in
            return object1.favoritedTime > object2.favoritedTime
        }
        return sorted
    }
}
