//
//  SignImage.swift
//  Hausa
//
//  Created by Emre Can Bolat on 18.12.17.
//  Copyright © 2017 MNM Team. All rights reserved.
//

import UIKit

@objc class SignImage: NSObject, NSCoding {
    
    var media_id: Int!
    var media_path: String
    var media_type: String
    
    var media: UIImage!
    
    init(id: Int, media_path: String, media_type: String) {
        self.media_id = id
        self.media_path = media_path
        self.media_type = media_type

        super.init()
        
        self.setMedia()
    }
    
    func setMedia() {
        if self.media == nil {
            if let path = Bundle.main.path(forResource: self.media_path, ofType: self.media_type, inDirectory: "images") {
                self.media = self.resizeImageToMaxSize(max: 600, path: path)
            } else {
                let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent(self.media_path + "." + self.media_type).path
                self.media = self.resizeImageToMaxSize(max: 600, path: path)
            }
            
        } 
    }
    
    required init(coder aDecoder: NSCoder) {
        self.media_id = aDecoder.decodeObject(forKey: "media_id") as? Int
        self.media_path = aDecoder.decodeObject(forKey: "media_path") as! String
        self.media_type = aDecoder.decodeObject(forKey: "media_type") as! String
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(media_id, forKey: "media_id")
        aCoder.encode(media_path, forKey: "media_path")
        aCoder.encode(media_type, forKey: "media_type")
    }
    
    func resizeImageToMaxSize(max: CGFloat, path: String) -> UIImage? {
        
        let url = NSURL(fileURLWithPath: path)
        let imageSource = CGImageSourceCreateWithURL(url, nil)
        if imageSource == nil { return nil }
        let options:NSDictionary = [
            kCGImageSourceCreateThumbnailWithTransform : kCFBooleanTrue!
            ,   kCGImageSourceCreateThumbnailFromImageIfAbsent : kCFBooleanTrue!
            ,   kCGImageSourceThumbnailMaxPixelSize : max
            ] as CFDictionary
        let imgRef = CGImageSourceCreateThumbnailAtIndex(imageSource!, 0, options)
        
        return UIImage(cgImage: imgRef!)
    }

}
