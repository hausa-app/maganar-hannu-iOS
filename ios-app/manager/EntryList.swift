//
//  EntryList.swift
//  Hausa
//
//  Created by Emre Can Bolat on 17.12.17.
//  Copyright © 2017 MNM Team. All rights reserved.
//

import Foundation

@objc class EntryList: NSObject {
    
    var searchResults: [Entry] = []
    var mostPopularEntries: [Entry] = []
    
    var categoryEntries: [Entry]!
    var categoryWordEntries: [Entry] = []
    
    var favoriteEntries: [Entry]! = []
    var recenteViewedEntries: [Entry]! = []
    
    var activeEntryList: [Entry]!
    
    func setSearchResults(entries: [Entry]) {
        self.searchResults = entries
    }
    
    func setMostPopularEntries(entries: [Entry]) {
        self.mostPopularEntries = entries
    }
    
    func setCategoryEntries(entries: [Entry]) {
        self.categoryEntries = entries
    }
    
    func setCategoryWordEntries(entries: [Entry]) {
        self.categoryWordEntries = entries
    }
    
    func setFavoriteEntries(entries: [Entry]) {
        self.favoriteEntries = entries
    }
    
    func setRecentViewedEntries(entries: [Entry]) {
        self.recenteViewedEntries = entries
    }
    
    func getSearchResults() -> [Entry] {
        return self.searchResults
    }
    
    func getMostPopularEntries() -> [Entry] {
        return self.mostPopularEntries
    }
    
    func getCategoryEntries() -> [Entry] {
        return self.categoryEntries
    }
    
    func getCategoryWordEntries() -> [Entry] {
        return self.categoryWordEntries
    }
    
    func getFavoriteEntries() -> [Entry] {
        return self.favoriteEntries
    }
    
    func getRecentViewedEntries() -> [Entry] {
        return self.recenteViewedEntries
    }
    
    func setActiveEntryList(_ entries: [Entry]) {
        self.activeEntryList = entries
    }
    
    func getActiveEntryList() -> [Entry]? {
        return self.activeEntryList
    }
    
}
