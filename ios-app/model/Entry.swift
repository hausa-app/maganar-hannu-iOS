//
//  Entry.swift
//  Hausa
//
//  Created by Emre Can Bolat on 17.12.17.
//  Copyright © 2017 MNM Team. All rights reserved.
//

import Foundation

@objc class Entry: NSObject, NSCoding {
    
    var id: Int!
    var lastModified: Date!
    var imageList: [SignImage]!
    var category: Category!
    
    var favorite: Bool!
    var favoritedTime: Date!
    
    var word: String!
    var translationList: [String]!
    
    func addImage(value: SignImage) { imageList.append(value) }
    func addWord(value: String?) { }
    
    init(id: Int, lastModified: Date, imageList: [SignImage], category: Category, favorite: Bool, favoritedTime: Date) {
        self.id = id
        self.lastModified = lastModified
        self.imageList = imageList
        self.category = category
        self.favorite = favorite
        self.favoritedTime = favoritedTime
    }
    
    required init(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: "id") as? Int
        self.lastModified = aDecoder.decodeObject(forKey: "lastModified") as? Date
        
        
        if let imageListObject = aDecoder.decodeObject(forKey: "imageList") as? NSData {
            imageList = NSKeyedUnarchiver.unarchiveObject(with: imageListObject as Data) as? [SignImage]
        }
        
        self.category = aDecoder.decodeObject(forKey: "category") as? Category
        self.favorite = aDecoder.decodeObject(forKey: "favorite") as? Bool
        self.favoritedTime = aDecoder.decodeObject(forKey: "favoritedTime") as? Date
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(lastModified, forKey: "lastModified")
        aCoder.encode(category, forKey: "category")
        aCoder.encode(favorite, forKey: "favorite")
        aCoder.encode(favoritedTime, forKey: "favoritedTime")
        aCoder.encode(NSKeyedArchiver.archivedData(withRootObject: imageList!), forKey: "imageList")
    }
    
    
}
