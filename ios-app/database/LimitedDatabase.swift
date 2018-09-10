//
//  LimitedDatabase.swift
//  Hausa
//
//  Created by Emre Can Bolat on 23.12.17.
//  Copyright © 2017 MNM Team. All rights reserved.
//

import SQLite

class LimitedDatabase: Database {
    
    func changeFavoriteStatus(entry: Entry) {
        do {
            try db.transaction {
                var check: Table
                if entry is HausaEntry {
                    check = joinForStats().filter(entry.word == hausa_table[hausa_entry])
                } else {
                    check = joinForStats().filter(entry.word == english_table[english_entry])
                }
                
                for i in entry.translationList {
                    var tempTable = check
                    if entry is HausaEntry {
                        tempTable = check.filter(i == english_table[english_entry])
                    } else {
                        tempTable = check.filter(i == hausa_table[hausa_entry])
                    }
                    
                    for word in try db.prepare(tempTable) {
                        let update = statsOwn.filter(word[entry_table[entry_id]] == stats_own_entryID)
                        executeQuery(update.update(favorite <- !word[statsOwn[favorite]], favoritedOn <- Int64(Date().toInt())))
                    }
                }
            }

        } catch {
            print("Unable to execute favorite status!")
        }
    }
    
    func updateViewed(entry: Entry) {
        do {
            try db.transaction {
                var check: Table
                if entry is HausaEntry {
                    check = joinForStats().filter(entry.word == hausa_table[hausa_entry])
                } else {
                    check = joinForStats().filter(entry.word == english_table[english_entry])
                }
                
                for i in entry.translationList {
                    var tempTable = check
                    if entry is HausaEntry {
                        tempTable = check.filter(i == english_table[english_entry])
                    } else {
                        tempTable = check.filter(i == hausa_table[hausa_entry])
                    }
                    
                    for word in try db.prepare(tempTable) {
                        let update = statsOwn.filter(word[entry_table[entry_id]] == stats_own_entryID)
                        executeQuery(update.update(newHits <- newHits + 1, statsOwn_lastViewed <- Int64(Date().toInt())))
                    }
                    
                }
            }

        } catch {
            print("Unable to update viewed count!")
        }
    }
    
    func removeViewed(entry: Entry) {
        do {
            try db.transaction {
                var check: Table
                if entry is HausaEntry {
                    check = joinForStats().filter(entry.word == hausa_table[hausa_entry])
                } else {
                    check = joinForStats().filter(entry.word == english_table[english_entry])
                }
                
                for i in entry.translationList {
                    var tempTable = check
                    if entry is HausaEntry {
                        tempTable = check.filter(i == english_table[english_entry])
                    } else {
                        tempTable = check.filter(i == hausa_table[hausa_entry])
                    }
                    
                    for word in try db.prepare(tempTable) {
                        let update = statsOwn.filter(word[entry_table[entry_id]] == stats_own_entryID)
                        executeQuery(update.update(statsOwn_lastViewed <- Int64(Utilities.getInitDate().toInt())))
                    }
                    
                }
            }
            
        } catch {
            print("Unable to update viewed count!")
        }
    }
    
    func getFavoriteList(_ limit: Int? = nil) -> [Entry]? {
        var entries: [Entry] = []
        do {
            for word in try db.prepare(joinAll().filter(statsOwn[favorite] == true).order(hausa_table[hausa_entry])) {
                self.buildHausaList(&entries, word: word)
                if entries.count == limit { break }
            }
            return entries.sorted(by: { $0.word < $1.word })
        } catch {
            print("Could not fetch request!")
            return nil
        }
    }
    
    func getMostPopularEntries(_ limit: Int? = nil) -> [Entry]? {
        var entries: [Entry] = []
        
        do {
            for word in try db.prepare(joinAll().filter(statsOwn[newHits] != 0).order(statsOwn[newHits].desc)) {
                self.buildHausaList(&entries, word: word)
                if entries.count == limit { break }
            }
        return entries
        } catch {
            print("Could not fetch request!")
            return nil
        }
    }
    
    func getMostPopularEntriesAt(_ from: Int, _ to: Int) -> [SignImage]? {
        var entries: [SignImage] = []
        
        do {
            for (index, word) in try db.prepare(thumbnail().filter(statsOwn[newHits] != 0).order(statsOwn[newHits].desc)).enumerated() {
                if index < from { continue }
                entries.append((AppConfig.getImage(with: word[media_table[media_id]]))!)
                if index == to { break }
            }

            return entries
        } catch {
            print("Could not fetch request!")
            return nil
        }
    }
    
    func getRecentViewedEntriesAt(_ from: Int, _ to: Int) -> [SignImage]? {
        var entries: [SignImage] = []
        
        do {
            for (index, word) in try db.prepare(thumbnail().filter(statsOwn[statsOwn_lastViewed] != Int64(Utilities.getInitDate().toInt())).order(statsOwn[statsOwn_lastViewed].desc)).enumerated() {
                if index < from { continue }
                entries.append((AppConfig.getImage(with: word[media_table[media_id]]))!)
                if index == to { break }
            }
            return entries
        } catch {
            print("Could not fetch request!")
            return nil
        }
    }
    
    func getRecentViewedEntries(_ limit: Int? = nil) -> [Entry]? {
        var entries: [Entry] = []
        
        do {
            for word in try db.prepare(joinAll().filter(statsOwn[statsOwn_lastViewed] != Int64(Utilities.getInitDate().toInt())).order(statsOwn[statsOwn_lastViewed].desc)) {
                self.buildHausaList(&entries, word: word)
                if entries.count == limit { break }
            }
            return entries
        } catch {
            print("Could not fetch request!")
            return nil
        }
    }
}
