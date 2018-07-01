//
//  Category.swift
//  Hausa
//
//  Created by Emre Can Bolat on 17.12.17.
//  Copyright © 2017 MNM Team. All rights reserved.
//

import Foundation

@objc class Category: NSObject, NSCoding {
    
    var categoryID: Int
    var category_hausa: String
    var category_english: String
    var color: Int
    var image: SignImage!
    
    init(categoryID: Int, category_hausa: String, category_english: String, color: Int, image: SignImage) {
        self.categoryID = categoryID
        self.category_hausa = category_hausa
        self.category_english = category_english
        self.color = color
        self.image = image
    }
    
    required init(coder aDecoder: NSCoder) {
        self.categoryID = aDecoder.decodeInteger(forKey: "categoryID")
        self.category_hausa = aDecoder.decodeObject(forKey: "category_hausa") as! String
        self.category_english = aDecoder.decodeObject(forKey: "category_english") as! String
        self.color = aDecoder.decodeInteger(forKey: "color")
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(categoryID, forKey: "categoryID")
        aCoder.encode(category_hausa, forKey: "category_hausa")
        aCoder.encode(category_english, forKey: "category_english")
        aCoder.encode(color, forKey: "color")
    }
    
}
