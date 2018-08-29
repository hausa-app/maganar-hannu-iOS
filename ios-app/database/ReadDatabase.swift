//
//  ReadDatabase.swift
//  Hausa
//
//  Created by Emre Can Bolat on 17.12.17.
//  Copyright © 2017 MNM Team. All rights reserved.
//

import Foundation
import SQLite

class ReadDatabase: Database {
    
    override func connect() {
        do {
            db = try Connection("\(path)/db.sqlite3", readonly: true)
        } catch {
            db = nil
            print ("Unable to open database with path: \(path)")
        }
    }
    
    func getCategories() -> [Category]? {
        var categoryList: [Category] = []
        do {
            for cat in try db.prepare(category_table) {
                categoryList.append(Category(categoryID: cat[category_id], category_hausa:  cat[category_catHausa], category_english:  cat[category_catEnglish],
                                             color: cat[category_color], image: getImage(mID: cat[category_mediaID])))
            }
            return categoryList
        } catch {
            print("Could not fetch categories!")
            return nil
        }
    }
    
    func getWordsForCategory(_ with: Int) -> [Entry]? {
        var entries: [Entry] = []
        
        do {
            for word in try db.prepare(joinAll().where(entrycat_table[entrycat_catID] == with)) {
                buildHausaList(&entries, word: word)
            }
            return entries
        } catch {
            print("Could not fetch words from categories!")
            return nil
        }
    }
    
    func getSearchRequestHausa(key: String) -> [Entry]? {
        var entries: [Entry] = []
        let wordKey = Utilities.hausaString(key)
        
        do {
            for word in try db.prepare(joinAll().filter(toHausa(hausa_table[hausa_entry]).like("\(wordKey)%")).limit(50).order(hausa_table[hausa_entry])) {
                buildHausaList(&entries, word: word)
            }
            return entries
        } catch {
            print("Could not fetch request!")
            return nil
        }
    }
    
    func getSearchRequestEnglish(key: String) -> [Entry]? {
        var entries: [Entry] = []
        let wordKey = Utilities.hausaString(key)
        
        do {
            for word in try db.prepare(joinAll().filter(toHausa(english_table[english_entry]).like("\(wordKey)%")).limit(50).order(hausa_table[hausa_entry])) {
                buildEnglishList(&entries, word: word)
            }
            return entries
        } catch {
            print("Could not fetch request!")
            return nil
        }
    }
    
    func getSearchRequest(key: String) -> [Entry]? {
        var entries: [Entry] = []
        let wordKey = Utilities.hausaString(key)
        
        do {
            for word in try db.prepare(joinAll().filter(
                toHausa(hausa_table[hausa_entry]).like("\(wordKey)%") || toHausa(english_table[english_entry]).like("\(wordKey)%")
                ).limit(50).order(hausa_table[hausa_entry])) {
                buildHausaList(&entries, word: word)
            }
            return entries
        } catch {
            print("Could not fetch request!")
            return nil
        }
    }
    
    func toHausa(_ word: Expression<String>) -> Expression<String> {
        return word
            .replace("ƙ",with: "k")
            .replace("ɗ",with: "d")
            .replace(" ",with: "")
            .replace("-", with: "")
            .replace("'", with: "")
            .replace("?", with: "")
            .replace("’", with: "")
            .replace("(", with: "")
            .replace(")", with: "")
            .lowercaseString
    }
    
    func getWordById(id: Int) -> Entry? {
        var entries: [Entry] = []
        
        do {
            for word in try db.prepare(joinAll().where(entry_hausaID == id)) {
                buildHausaList(&entries, word: word)
            }
            return entries.first;
        } catch {
            print("Could not fetch request!")
            return nil
        }
    }
    
}
