//
//  HausaEntry.swift
//  Hausa
//
//  Created by Emre Can Bolat on 17.12.17.
//  Copyright © 2017 MNM Team. All rights reserved.
//

import SQLite

class HausaEntry: Entry {
    
    init(id: Int, lastModified: Date, imageList: [SignImage], category: Category, hausa: String, englishList: [String], favorite: Bool, favoritedTime: Date) {
        super.init(id: id, lastModified: lastModified, imageList: imageList, category: category, favorite: favorite, favoritedTime: favoritedTime)
        self.word = hausa
        self.translationList = englishList
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.word = aDecoder.decodeObject(forKey: "word") as! String
        self.translationList = aDecoder.decodeObject(forKey: "translationList") as! [String]
    }
    
    override func encode(with aCoder: NSCoder) {
        super.encode(with: aCoder)
        aCoder.encode(word, forKey: "word")
        aCoder.encode(translationList, forKey: "translationList")
    }
    
    override func addWord(value: String?) {
        if value == nil { return }
        for word in translationList {
            if word == value { return }
        }
        translationList.append(value!)
    }

}
