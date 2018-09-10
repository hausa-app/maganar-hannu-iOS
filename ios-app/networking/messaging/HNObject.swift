//
//  HNObject.swift
//  Hausa
//
//  Created by Emre Can Bolat on 15.01.18.
//  Copyright © 2018 MNM Team. All rights reserved.
//
import Foundation

class HNObject {
    
    let object = JSONObject()
    
    func serializeToJSON() -> JSONObject {
        
        return object
    }
    
    func convertToData() {
        
    }
    
    func readParams(object: JSONObject) {
        
    }
    
}

class HN_requestDatabaseDate: HNObject {
    static let constructor = 0x44572638
    
    override func serializeToJSON() -> JSONObject {
        object.put(name: "constructor", parameter: HN_requestDatabaseDate.constructor)
        return object
    }
}

class HN_receivedDatabaseDate: HNObject {
    static let constructor = 0x03424534
    var date: Int64!
    
    override func serializeToJSON() -> JSONObject {
        object.put(name: "constructor", parameter: HN_requestDatabaseDate.constructor)
        return object
    }
    
    override func readParams(object: JSONObject) {
        date = Int64(object.getString(name: "value")!)
    }
}

class HN_requestUpdatedEntries: HNObject {
    static let constructor = 0x468827f0
    
    override func serializeToJSON() -> JSONObject {
        object.put(name: "constructor", parameter: HN_requestUpdatedEntries.constructor)
        object.put(name: "databaseTimestamp", parameter: UserConfig.getDatabaseTimestamp())
        return object
    }
}

class HN_updatedEntries: HNObject {
    static let constructor = 0x0348950f
    
    var categories: [HN_category] = []
    var entries: [HN_entry] = []
    var entryCategories: [HN_entry_cat] = []
    var hausaEntries: [HN_hausa] = []
    var englishEntries: [HN_english] = []
    var mediaEntries: [HN_media] = []
    var entryMedias: [HN_entry_media] = []
    
    override func readParams(object: JSONObject) {
        for i in (object.getArray(name: "category")?.values)! {
            let category = HN_category()
            category.readParams(object: i as! JSONObject)
            categories.append(category)
        }
        
        for i in (object.getArray(name: "entry")?.values)! {
            let entry = HN_entry()
            entry.readParams(object: i as! JSONObject)
            entries.append(entry)
        }
        
        for i in (object.getArray(name: "entry_cat")?.values)! {
            let entryCat = HN_entry_cat()
            entryCat.readParams(object: i as! JSONObject)
            entryCategories.append(entryCat)
        }
        
        for i in (object.getArray(name: "hausa")?.values)! {
            let hausa = HN_hausa()
            hausa.readParams(object: i as! JSONObject)
            hausaEntries.append(hausa)
        }
        
        for i in (object.getArray(name: "english")?.values)! {
            let english = HN_english()
            english.readParams(object: i as! JSONObject)
            englishEntries.append(english)
        }
        
        for i in (object.getArray(name: "media")?.values)! {
            let media = HN_media()
            media.readParams(object: i as! JSONObject)
            mediaEntries.append(media)
        }
        
        for i in (object.getArray(name: "entry_media")?.values)! {
            let entry_media = HN_entry_media()
            entry_media.readParams(object: i as! JSONObject)
            entryMedias.append(entry_media)
        }
    }
}

class HN_category: HNObject {
    var id: Int!
    var hausa: String!
    var english: String!
    var timestamp: Int64!
    var flag: Bool!
    var color: String!
    var media_id: Int!
    
    override func readParams(object: JSONObject) {
        id = object.getInt(name: "id")
        hausa = object.get(name: "cat_hausa") as! String
        english = object.get(name: "cat_hausa") as! String
        timestamp = Int64(object.getString(name: "timestamp")!)
        flag = object.getBool(name: "flag")
        color = object.get(name: "color") as! String;
        media_id = object.getInt(name: "media_id")
    }
}

class HN_entry: HNObject {
    var id: Int!
    var english_id: Int!
    var hausa_id: Int!
    var timestamp: Int64!
    var flag: Bool!
    
    override func readParams(object: JSONObject) {
        id = object.getInt(name: "id")
        english_id = object.getInt(name: "english_id")
        hausa_id = object.getInt(name: "hausa_id")
        timestamp = Int64(object.getString(name: "timestamp")!)
        flag = object.getBool(name: "flag")
    }
}

class HN_entry_cat: HNObject {
    var id: Int!
    var cat_id: Int!
    var timestamp: Int64!
    var flag: Bool!
    
    override func readParams(object: JSONObject) {
        id = object.getInt(name: "id")
        cat_id = object.getInt(name: "cat_id")
        timestamp = Int64(object.getString(name: "timestamp")!)
        flag = object.getBool(name: "flag")
    }
}

class HN_hausa: HNObject {
    var id: Int!
    var entry: String!
    var timestamp: Int64!
    var flag: Bool!
    
    override func readParams(object: JSONObject) {
        id = object.getInt(name: "id")
        entry = object.get(name: "entry_hausa") as! String
        timestamp = Int64(object.getString(name: "timestamp")!)
        flag = object.getBool(name: "flag")
    }
}

class HN_english: HNObject {
    var id: Int!
    var entry: String!
    var timestamp: Int64!
    var flag: Bool!
    
    override func readParams(object: JSONObject) {
        id = object.getInt(name: "id")
        entry = object.get(name: "entry_english") as! String
        timestamp = Int64(object.getString(name: "timestamp")!)
        flag = object.getBool(name: "flag")
    }
}

class HN_media: HNObject {
    var id: Int!
    var url: String!
    var type: String!
    var timestamp: Int64!
    var flag: Bool!
    
    override func readParams(object: JSONObject) {
        id = object.getInt(name: "id")
        url = object.get(name: "media_url") as! String
        type = object.get(name: "media_type") as! String
        timestamp = Int64(object.getString(name: "timestamp")!)
        flag = object.getBool(name: "flag")
    }
}

class HN_entry_media: HNObject {
    var id: Int!
    var media_id: Int!
    var timestamp: Int64!
    var flag: Bool!
    
    override func readParams(object: JSONObject) {
        id = object.getInt(name: "id")
        media_id = object.getInt(name: "media_id")
        timestamp = Int64(object.getString(name: "timestamp")!)
        flag = object.getBool(name: "flag")
    }
}
