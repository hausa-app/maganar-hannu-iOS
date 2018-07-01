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
    
    var categoryList: [Category]
    
    init() {
        self.categoryList = database.getCategories()!
        self.searchManager = SearchManager(database: database)
        self.statisticsManager = StatisticsManager(database: limitedDatabase)

        self.entryList.setFavoriteEntries(entries: statisticsManager.getFavoriteEntries())
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
        self.entryList.setFavoriteEntries(entries: statisticsManager.getFavoriteEntries())
    }
    
    func addHit(entry: Entry) {
        self.statisticsManager.updateViewed(entry: entry)
    }
    
    func removeViewed(entry: Entry) {
        self.statisticsManager.removeViewed(entry: entry)
    }
    
    func getPopularEntries(_ limit: Int? = nil) -> [Entry] {
        self.entryList.setMostPopularEntries(entries: statisticsManager.getMostPopularEntries(limit))
        return self.entryList.getMostPopularEntries()
    }
    
    func getRecentViewedEntries(_ limit: Int? = nil) -> [Entry] {
        self.entryList.setRecentViewedEntries(entries: statisticsManager.getRecentViewedEntries(limit))
        return self.entryList.getRecentViewedEntries()
    }
    
    func getFavoriteEntries(_ limit: Int? = nil) -> [Entry] {
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
