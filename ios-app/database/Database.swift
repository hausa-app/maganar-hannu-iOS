//
//  Database.swift
//  Hausa
//
//  Created by Emre Can Bolat on 16.12.17.
//  Copyright © 2017 MNM Team. All rights reserved.
//

import Foundation
import SQLite

public class Database {
    
    var db: Connection!
    
    let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    
    let category_table = Table("category")
    let category_id = Expression<Int>("id")
    let category_catHausa = Expression<String>("cat_hausa")
    let category_catEnglish = Expression<String>("cat_english")
    let category_color = Expression<Int>("color")
    let category_mediaID = Expression<Int>("media_id")
    let category_timestamp = Expression<Int64>("timestamp")
    
    let english_table = Table("english")
    let english_id = Expression<Int>("id")
    let english_entry = Expression<String>("entry_english")
    let english_timestamp = Expression<Int64>("timestamp")
    
    let entry_table = Table("entry")
    let entry_id = Expression<Int>("id")
    let entry_englishID = Expression<Int>("english_id")
    let entry_hausaID = Expression<Int>("hausa_id")
    let entry_timestamp = Expression<Int64>("timestamp")
    
    let entrycat_table = Table("entry_cat")
    let entrycat_id = Expression<Int>("id")
    let entrycat_catID = Expression<Int>("cat_id")
    let entrycat_timestamp = Expression<Int64>("timestamp")

    let entrymedia_table = Table("entry_media")
    let entrymedia_id = Expression<Int>("id")
    let entrymedia_mediaID = Expression<Int>("media_id")
    let entrymedia_timestamp = Expression<Int64>("timestamp")

    let hausa_table = Table("hausa")
    let hausa_id = Expression<Int>("id")
    let hausa_entry = Expression<String>("entry_hausa")
    let hausa_timestamp = Expression<Int64>("timestamp")
    
    let media_table = Table("media")
    let media_id = Expression<Int>("id")
    let media_url = Expression<String>("media_url")
    let media_type = Expression<String>("media_type")
    let media_timestamp = Expression<Int64>("timestamp")
    
    let statsOwn = Table("stats_own")
    let stats_own_entryID = Expression<Int>("id")
    let newHits = Expression<Int>("new_hits")
    let favorite = Expression<Bool>("favorite")
    let favoritedOn = Expression<Int64>("favorited_on")
    let statsOwn_lastViewed = Expression<Int64>("last_viewed")
    
    init() {
        connect()
    }
    
    func connect() {
        do {
            db = try Connection("\(path)/db.sqlite3")
        } catch {
            db = nil
            print ("Unable to open database with path: \(path)")
        }
    }
    
    func disconnect() {
        db = nil
        print ("Database closed")
    }
    
    func executeQuery(_ execution: String){
        do {
            try db.run(execution)
        } catch {
            print ("Unable to run execution")
        }
    }
    
    func executeQueryR(_ execution: Any) -> Int {
        do {
            if execution is Insert {
                return try Int(db.run(execution as! Insert))
            }
            
        } catch {
            print ("Unable to run execution")
        }
        return 0
    }
    
    func executeQuery(_ execution: Any) {
        do {
            if execution is Insert {
                try db.run(execution as! Insert)
            } else if execution is Update {
                try db.run(execution as! Update)
            }
            
        } catch {
            print ("Unable to run execution")
        }
    }
    
    func joinAll() -> Table {
        return entry_table
            .join(hausa_table, on: entry_table[entry_hausaID] == hausa_table[hausa_id])
            .join(english_table, on: entry_table[entry_englishID] == english_table[english_id])
            .join(entrycat_table, on: entry_table[entry_id] == entrycat_table[entrycat_id])
            .join(category_table, on: entrycat_table[entrycat_catID] == category_table[category_id])
            .join(entrymedia_table, on: entry_table[entry_id] == entrymedia_table[entrymedia_id])
            .join(media_table, on: entrymedia_table[entrymedia_mediaID] == media_table[media_id])
            .join(statsOwn, on: entry_table[entry_id] == statsOwn[stats_own_entryID])
    }
    
    func joinForStats() -> Table {
        return entry_table
            .join(hausa_table, on: entry_table[entry_hausaID] == hausa_table[hausa_id])
            .join(english_table, on: entry_table[entry_englishID] == english_table[english_id])
            .join(statsOwn, on: entry_table[entry_id] == statsOwn[stats_own_entryID])
    }
    
    func thumbnail() -> Table {
        return entry_table
            .join(entrymedia_table, on: entry_table[entry_id] == entrymedia_table[entrymedia_id])
            .join(media_table, on: entrymedia_table[entrymedia_mediaID] == media_table[media_id])
            .join(statsOwn, on: entry_table[entry_id] == statsOwn[stats_own_entryID])
    }
    
    func buildEnglishList(_ entries: inout [Entry], word: Row) {
        var existing = false
        entries.forEach( { entry in
            
            let newHausaWord = word[hausa_table[hausa_entry]]
            let newMediaID = word[media_table[media_id]]
            
            entry.translationList.forEach( { translation in
                
                if newHausaWord == translation && word[english_table[english_entry]] == entry.word {
                    existing = true
                    if !(entry.imageList.contains(where: { $0.media_id ==  newMediaID })) { entry.imageList.append(getImage(mID: newMediaID)) }
                }
            })
            
            entry.imageList.forEach( { image in
                
                if newMediaID == image.media_id && word[english_table[english_entry]] == entry.word {
                    existing = true
                    if !entry.translationList.contains(newHausaWord) { entry.translationList.append(newHausaWord) }
                }
            })
        })
        
        if !existing {
            entries.append(EnglishEntry(
                id: word[entry_table[entry_id]],
                lastModified: word[entry_table[entry_timestamp]].toDate(),
                imageList: [getImage(mID: word[media_table[media_id]])],
                category: Category(categoryID: word[entrycat_table[entrycat_catID]], category_hausa: word[category_table[category_catHausa]], category_english: word[category_table[category_catEnglish]], color: word[category_table[category_color]], image: getImage(mID: word[category_table[category_mediaID]])),
                english: word[english_table[english_entry]],
                hausaList: [word[hausa_table[hausa_entry]]],
                favorite: word[statsOwn[favorite]],
                favoritedTime: word[statsOwn[favoritedOn]].toDate()
            ))
        }
    }
    
    func buildHausaList(_ entries: inout [Entry], word: Row) {
        var existing = false
        entries.forEach( { entry in
            
            let newEnglishWord = word[english_table[english_entry]]
            let newMediaID = word[media_table[media_id]]
            
            entry.translationList.forEach( { translation in
                
                if newEnglishWord == translation && word[hausa_table[hausa_entry]] == entry.word {
                    existing = true
                    if !(entry.imageList.contains(where: { $0.media_id ==  newMediaID })) { entry.imageList.append(getImage(mID: newMediaID)) }
                }
            })
            
            entry.imageList.forEach( { image in
                
                if newMediaID == image.media_id && word[hausa_table[hausa_entry]] == entry.word {
                    existing = true
                    if !entry.translationList.contains(newEnglishWord) { entry.translationList.append(newEnglishWord) }
                }
            })
        })
        
        if !existing {
            entries.append(HausaEntry(
                id: word[entry_table[entry_id]],
                lastModified: word[entry_table[entry_timestamp]].toDate(),
                imageList: [getImage(mID: word[media_table[media_id]])],
                category: Category(categoryID: word[entrycat_table[entrycat_catID]], category_hausa: word[category_table[category_catHausa]], category_english: word[category_table[category_catEnglish]], color: word[category_table[category_color]], image: getImage(mID: word[category_table[category_mediaID]])),
                hausa: word[hausa_table[hausa_entry]],
                englishList: [word[english_table[english_entry]]],
                favorite: word[statsOwn[favorite]],
                favoritedTime: word[statsOwn[favoritedOn]].toDate()
            ))
        }
    }

    func getImage(mID: Int)  -> SignImage {
        let image = AppConfig.getImage(with: mID)
        if  image != nil { return image! }
        do {
            
            for word in try db.prepare(media_table.filter(mID == media_id)) {
                let image = SignImage(id: mID, media_path: word[media_url], media_type: word[media_type])
                AppConfig.addImage(image)
                return image
            }
            
        } catch {
            print("Could not get images for entry \(mID)")
        }
        return image!
    }
}

extension Database {
    func tableExists(tableName: String) -> Bool {
        do {
            let count:Int64 =
                try db.scalar(
                    "SELECT EXISTS(SELECT name FROM sqlite_master WHERE name = ?)", tableName
                    ) as! Int64
            if count>0{
                return true
            }
            else{
                return false
            }
        } catch {
            print ("Unable to run execution")
            return false
        }

    }
}
