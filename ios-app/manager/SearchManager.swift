//
//  SearchManager.swift
//  Hausa
//
//  Created by Emre Can Bolat on 17.12.17.
//  Copyright © 2017 MNM Team. All rights reserved.
//

import Foundation

class SearchManager {
    
    var database: ReadDatabase
    
    init(database: ReadDatabase) {
        self.database = database
    }
    
    func handleSearchRequest(key: String) -> [Entry] {
        let filter = UserConfig.getFilterType()
        
        if filter == .hausa {
            return Utilities.sortList(entries: database.getSearchRequestHausa(key: key)!)
        } else if filter == .english {
            return Utilities.sortList(entries: database.getSearchRequestEnglish(key: key)!)
        } else {
            return getHausaAndEnglishRequests(key: key)
        }
    }
    
    func getHausaAndEnglishRequests(key: String) -> [Entry] {
        let requestAll = database.getSearchRequest(key: key)
        
        var result: [Entry] = []
        
        if let request = requestAll {
            for value in request {
                if !result.contains(where: { $0.id == value.id } ) {
                    result.append(value)
                }
            }
        }
        
        return Utilities.sortList(entries: result)
        
    }
}
