//
//  DatabaseInitializer.swift
//  Hausa
//
//  Created by Emre Can Bolat on 16.12.17.
//  Copyright © 2017 MNM Team. All rights reserved.
//

import Foundation
import SQLite

class DatabaseInitializer: Database {
    
    func initTables() {
        
        do {
            try db.transaction {
                try db.run(category_table.create(ifNotExists: true) { table in
                    table.column(category_id, primaryKey: .autoincrement)
                    table.column(category_catHausa)
                    table.column(category_catEnglish)
                    table.column(category_color)
                    table.column(category_mediaID)
                    table.column(category_timestamp, defaultValue: 332145240)
                    
                    table.foreignKey(category_mediaID, references: media_table, media_id, delete: .cascade)
                })
                
                try db.run( english_table.create(ifNotExists: true) { table in
                    table.column(english_id, primaryKey: .autoincrement)
                    table.column(english_entry)
                    table.column(english_timestamp, defaultValue: 332145240)
                })
                
                try db.run( entry_table.create(ifNotExists: true) { table in
                    table.column(entry_id, primaryKey: .autoincrement)
                    table.column(entry_englishID)
                    table.column(entry_hausaID)
                    table.column(entry_timestamp, defaultValue: 332145240)
                    
                    table.foreignKey(entry_englishID, references: english_table, english_id, delete: .cascade)
                    table.foreignKey(entry_hausaID, references:  hausa_table, hausa_id, delete: .cascade)
                })
                
                try db.run( entrycat_table.create(ifNotExists: true) { table in
                    table.column(entrycat_id)
                    table.column(entrycat_catID)
                    table.column(entrycat_timestamp, defaultValue: 332145240)
                    
                    table.foreignKey(entrycat_catID, references: category_table, category_id, delete: .cascade)
                    table.foreignKey(entrycat_id, references: entry_table, entry_id, delete: .cascade)
                })
                
                try db.run( entrymedia_table.create(ifNotExists: true) { table in
                    table.column(entrymedia_id)
                    table.column(entrymedia_mediaID)
                    table.column(entrymedia_timestamp, defaultValue: 332145240)
                    
                    table.foreignKey(entrymedia_mediaID, references: media_table, media_id, delete: .cascade)
                    table.foreignKey(entrymedia_id, references: entry_table, entry_id, delete: .cascade)
                })
                
                try db.run( hausa_table.create(ifNotExists: true) { table in
                    table.column(hausa_id, primaryKey: .autoincrement)
                    table.column(hausa_entry)
                    table.column(hausa_timestamp, defaultValue: 332145240)
                })
                
                try db.run( media_table.create(ifNotExists: true) { table in
                    table.column(media_id, primaryKey: .autoincrement)
                    table.column(media_url)
                    table.column(media_type)
                    table.column(media_timestamp, defaultValue: 332145240)
                })
                
                try db.run( statsOwn.create(ifNotExists: true) { table in
                    table.column(stats_own_entryID)
                    table.column(newHits, defaultValue: 0)
                    table.column(favorite, defaultValue: false)
                    table.column(favoritedOn, defaultValue: 332145240)
                    table.column(statsOwn_lastViewed, defaultValue: 332145240)
                    table.foreignKey(stats_own_entryID, references: entry_table, entry_id, delete: .cascade)
                })
                
                
                try db.run(String(contentsOfFile: Bundle.main.path(forResource: "insert_category", ofType: "txt", inDirectory: "various")!, encoding: String.Encoding.utf8))
                try db.run(String(contentsOfFile: Bundle.main.path(forResource: "insert_english", ofType: "txt", inDirectory: "various")!, encoding: String.Encoding.utf8))
                try db.run(String(contentsOfFile: Bundle.main.path(forResource: "insert_entry", ofType: "txt", inDirectory: "various")!, encoding: String.Encoding.utf8))
                try db.run(String(contentsOfFile: Bundle.main.path(forResource: "insert_entry_cat", ofType: "txt", inDirectory: "various")!, encoding: String.Encoding.utf8))
                try db.run(String(contentsOfFile: Bundle.main.path(forResource: "insert_entry_media", ofType: "txt", inDirectory: "various")!, encoding: String.Encoding.utf8))
                try db.run(String(contentsOfFile: Bundle.main.path(forResource: "insert_hausa", ofType: "txt", inDirectory: "various")!, encoding: String.Encoding.utf8))
                try db.run(String(contentsOfFile: Bundle.main.path(forResource: "insert_media", ofType: "txt", inDirectory: "various")!, encoding: String.Encoding.utf8))
                try db.run(String(contentsOfFile: Bundle.main.path(forResource: "insert_stats_own", ofType: "txt", inDirectory: "various")!, encoding: String.Encoding.utf8))
                
            }
        } catch { }
    }
}

    /*
    func addImagesToStack() {
        do {
            for word in try db.prepare(media_table) {
                if let _ = AppConfig.imageList.first(where: { $0.media_id == word[media_entryID] && $0.media_path == word[media_url] && $0.media_type == word[media_type] }) {
                    continue
                }
                AppConfig.addImage(SignImage(id: word[media_entryID], media_path: word[media_url], media_type: word[media_type]))
            }
        } catch {
            print("Insertion of image failed!")
        }
    }

 */
