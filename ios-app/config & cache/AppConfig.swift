//
//  AppConfig.swift
//  Hausa
//
//  Created by Emre Can Bolat on 27.12.17.
//  Copyright © 2017 MNM Team. All rights reserved.
//

import Foundation

class AppConfig: Config {
    
    static var imageList: [SignImage] = []
    static var databaseTimestampServer: Int64!
    static var lastCheckedDBTimestampServer: Int64!
    
    static func getImage(with: Int) -> SignImage? {
        return imageList.first(where: { $0.media_id == with })
    }
    
    static func addImage(_ signImage: SignImage?) {
        if signImage == nil { return}
        imageList.append(signImage!)
        save(true)
    }
    
    static func readConfig() {
        if let imageListObject = preferences.value(forKey: "imageList") as? NSData {
            imageList = NSKeyedUnarchiver.unarchiveObject(with: imageListObject as Data) as! [SignImage]
        }
        if let lastChecked = preferences.value(forKey: "lastChecked") {
            lastCheckedDBTimestampServer = lastChecked as? Int64
        }
        if let dbTSServer = preferences.value(forKey: "databaseTimestampServer") {
            databaseTimestampServer = dbTSServer as? Int64
        }
    }
    
    static func save(_ alone: Bool? = false) {
        preferences.set(NSKeyedArchiver.archivedData(withRootObject: imageList), forKey: "imageList")
        preferences.set(lastCheckedDBTimestampServer, forKey: "lastChecked")
        preferences.set(databaseTimestampServer, forKey: "databaseTimestampServer")
        if alone! { preferences.synchronize() }
    }
    
    static func getDatabaseTimestampServer() -> Int64? {
        return databaseTimestampServer
    }
    
    static func setDatabaseTimestampServer(_ timestamp: Int64) {
        self.databaseTimestampServer = timestamp
    }
    
    static func getLastCheckedDBTimestampServer() -> Int64? {
        return lastCheckedDBTimestampServer
    }
    
    static func setLastCheckedDBTimestampServer(_ timestamp: Int64) {
        self.lastCheckedDBTimestampServer = timestamp
    }
    
}
