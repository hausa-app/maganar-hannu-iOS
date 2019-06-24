//
//  ScreenManager.swift
//  Hausa
//
//  Created by Emre Can Bolat on 17.12.17.
//  Copyright © 2017 MNM Team. All rights reserved.
//

import Foundation

class ScreenManager {
    
    static let instance = ScreenManager()
    
    let database = ReadDatabase()
    let limitedDatabase = LimitedDatabase()
    
    let searchManager: SearchManager
    let statisticsManager: StatisticsManager
    
    var entryList: EntryList = EntryList()
    
    var categoryList: [Category]?
    
    init() {
        if let categories = database.getCategories() {
            self.categoryList = categories
        }
        
        self.searchManager = SearchManager(database: database)
        self.statisticsManager = StatisticsManager(database: limitedDatabase)
 
        if let favorites = statisticsManager.getFavoriteEntries() {
            self.entryList.setFavoriteEntries(entries: favorites)
        }
    }
    
    func update() {
        self.categoryList = database.getCategories()!
    }
    
    func getEntryList() -> EntryList? {
        return self.entryList
    }
    
    func getSearchResults() -> [Entry] {
        return self.entryList.getSearchResults()
    }
    
    func clearSearchResults() {
        self.entryList.searchResults.removeAll()
    }
    
    func getCategoryEntries() -> [Entry]? {
        return self.entryList.getCategoryEntries()
    }
    
    func getCategoryWordEntries() -> [Entry] {
        return self.entryList.getCategoryWordEntries()
    }
    
    func setCategoryWords(with: Int) {
        let words = database.getWordsForCategory(with)!
        self.entryList.setCategoryWordEntries(entries: words )
    }
    
    func setSearchResults(key: String) {
        self.entryList.setSearchResults(entries: searchManager.handleSearchRequest(key: key))
    }
    
    func setFavorited(entry: Entry) {
        self.statisticsManager.changeFavoriteStatus(entry: entry)
        if let favorites = statisticsManager.getFavoriteEntries() {
            self.entryList.setFavoriteEntries(entries: favorites)
        }
    }
    
    func addHit(entry: Entry) {
        self.statisticsManager.updateViewed(entry: entry)
    }
    
    func removeViewed(entry: Entry) {
        self.statisticsManager.removeViewed(entry: entry)
    }
    
    func getPopularEntries(_ limit: Int? = nil) -> [Entry]? {
        if let popular = statisticsManager.getMostPopularEntries(limit) {
            self.entryList.setMostPopularEntries(entries: popular)
        }
        return self.entryList.getMostPopularEntries()
    }
    
    func getRecentViewedEntries(_ limit: Int? = nil) -> [Entry]? {
        if let recentViewed = statisticsManager.getRecentViewedEntries(limit) {
            self.entryList.setRecentViewedEntries(entries: recentViewed)
        }
        return self.entryList.getRecentViewedEntries()
    }
    
    func getFavoriteEntries(_ limit: Int? = nil) -> [Entry]? {
        return statisticsManager.getFavoriteEntries(limit)
    }
    
    func getMostPopularEntriesAt(_ from: Int, _ to: Int) -> [SignImage]? {
        return statisticsManager.getMostPopularEntriesAt(from, to)
    }
    
    func getRecentViewedEntriesAt(_ from: Int, _ to: Int) -> [SignImage]? {
        return statisticsManager.getRecentViewedEntriesAt(from, to)
    }
    
    func setActiveEntryList(_ list: [Entry]) {
        self.entryList.setActiveEntryList(list)
    }
    
    func getActiveEntryList() -> [Entry]? {
        return self.entryList.getActiveEntryList()
    }
    
    func getWordByID(id: Int) -> Entry? {
        let word = self.database.getWordById(id: id)
        if (word != nil) { self.setActiveEntryList([word!]) }
        return word
    }
}
