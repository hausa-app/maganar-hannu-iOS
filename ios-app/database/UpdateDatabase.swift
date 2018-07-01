//
//  UpdateDatabase.swift
//  Hausa
//
//  Created by Emre Can Bolat on 16.01.18.
//  Copyright © 2018 MNM Team. All rights reserved.
//

import SQLite

class UpdateDatabase: Database {
    
    func handleCategoryUpdate(_ category: HN_category) {
        do {
            try db.transaction {

                let table = category_table.filter(category.id == category_id)
                
                let count = try db.scalar(table.count)
                if count == 0 {
                    if category.flag {
                        try db.run(category_table.insert( category_id <- category.id, category_catHausa <- category.hausa, category_catEnglish <- category.english, category_timestamp <- category.timestamp, category_color <- UIColor.hexStringToInt(hex: category.color), category_mediaID <- category.media_id))
                    }
                } else {
                    if category.flag {
                        try db.run(table.update( category_catHausa <- category.hausa, category_catEnglish <- category.english, category_timestamp <- category.timestamp, category_color <- UIColor.hexStringToInt(hex: category.color), category_mediaID <- category.media_id ))
                    } else {
                        try db.run(table.delete())
                    }
                }
            }

        } catch {
            print("Could not handle new/delete/update category!")
        }
    }
    
    func handleEnglishEntryUpdate(_ english: HN_english) {
        do {
            try db.transaction {
                
                let table = english_table.filter(english.id == english_id)
                
                let count = try db.scalar(table.count)
                if count == 0 {
                    if english.flag {
                        try db.run(english_table.insert( english_id <- english.id, english_entry <- english.entry, english_timestamp <- english.timestamp ))
                    }
                } else {
                    if english.flag {
                        try db.run(table.update( english_entry <- english.entry, english_timestamp <- english.timestamp ))
                    } else {
                        try db.run(table.delete())
                    }
                }
                
            }
        } catch {
            print("Could not handle new/delete/update english!")
        }
    }
    
    func handleEntryUpdate(_ entry: HN_entry) {
        do {
            try db.transaction {
                
                let table = entry_table.filter(entry.id == entry_id)
                
                let count = try db.scalar(table.count)
                if count == 0 {
                    if entry.flag {
                        try db.run(entry_table.insert( entry_id <- entry.id, entry_englishID <- entry.english_id, entry_hausaID <- entry.hausa_id, entry_timestamp <- entry.timestamp ))
                        try db.run(statsOwn.insert( stats_own_entryID <- entry.id ))
                    }
                } else {
                    if !entry.flag {
                        try db.run(table.delete())
                        //delete stats
                    }
                }
                
            }
        } catch {
            print("Could not handle new/delete/update entry!")
        }
    }
    
    func handleHausaEntryUpdate(_ hausa: HN_hausa) {
        do {
            try db.transaction {
                let table = hausa_table.filter(hausa.id == hausa_id)
                
                let count = try db.scalar(table.count)
                if count == 0 {
                    if hausa.flag {
                        try db.run(hausa_table.insert( hausa_id <- hausa.id, hausa_entry <- hausa.entry, hausa_timestamp <- hausa.timestamp ))
                    }
                } else {
                    if hausa.flag {
                        try db.run(table.update( hausa_entry <- hausa.entry, hausa_timestamp <- hausa.timestamp ))
                    } else {
                        try db.run(table.delete())
                    }
                }
            }
        } catch {
            print("Could not handle new/delete/update hausa!")
        }
    }
    
    func handleMediaEntriesUpdate(_ mediaEntries: [HN_media], _ completionHandler: @escaping () -> Void?) {
        if mediaEntries.count == 0 { completionHandler() }
        for (idx, media) in mediaEntries.enumerated() {
            do {
                try db.transaction {
                    let table = media_table.filter(media.id == media_id)
                    
                    let count = try db.scalar(table.count)
                    if count == 0 {
                        if media.flag {
                            try db.run(media_table.insert( media_id <- media.id, media_url <- media.url, media_type <- media.type, media_timestamp <- media.timestamp ))
                            if idx == mediaEntries.count - 1 { StartupController.instance.networkManager.fetchImageFromUrl(media.url + "." + media.type, completionHandler) }
                            else { StartupController.instance.networkManager.fetchImageFromUrl(media.url + "." + media.type, { return nil }) }
                        }
                    } else {
                        if media.flag {
                            try db.run(table.update( media_url <- media.url, media_type <- media.type, media_timestamp <- media.timestamp ))
                        } else {
                            try db.run(table.delete())
                        }
                    }
                }
            } catch {
                print("Could not handle new/delete/update media!")
            }
        }
    }
    
    func handleEntryMediaUpdate(_ entryMedia: HN_entry_media) {
        do {
            try db.transaction {
                let table = entrymedia_table.filter(entryMedia.id == entrymedia_id && entryMedia.media_id == entrymedia_mediaID )
                
                let count = try db.scalar(table.count)
                if count == 0 {
                    if entryMedia.flag {
                        try db.run(entrymedia_table.insert( entrymedia_id <- entryMedia.id, entrymedia_mediaID <- entryMedia.media_id, media_timestamp <- entryMedia.timestamp ))
                    }
                } else {
                    if !entryMedia.flag {
                        try db.run(table.delete())
                    }
                }
            }
        } catch {
            print("Could not handle new/delete/update media!")
        }
    }
    
    func handleEntryCategoriesUpdate(_ entryCat: HN_entry_cat) {
        do {
            try db.transaction {
                let table = entrycat_table.filter(entryCat.id == entrycat_id && entryCat.cat_id == entrycat_catID)
                
                let count = try db.scalar(table.count)
                if count == 0 {
                    if entryCat.flag {
                        try db.run(entrycat_table.insert( entrycat_id <- entryCat.id, entrycat_catID <- entryCat.cat_id, entrycat_timestamp <- entryCat.timestamp ))
                    }
                } else {
                    if !entryCat.flag {
                        try db.run(table.delete())
                    }
                }
            }
        } catch {
            print("Could not handle new/delete/update entryCat!")
        }
    }
}
