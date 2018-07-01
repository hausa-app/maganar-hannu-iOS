//
//  Config.swift
//  Hausa
//
//  Created by Emre Can Bolat on 27.12.17.
//  Copyright © 2017 MNM Team. All rights reserved.
//

import Foundation

enum AvailableUpdates {
    case available
    case upToDate
    case notChecked
}

class Config {
    
    static let preferences = UserDefaults.standard
    
    static func synced(_ lock: Any, closure: () -> ()) {
        objc_sync_enter(lock)
        closure()
        objc_sync_exit(lock)
    }
    
    static func syncedR<T>(_ lock: Any, closure: ()->T) -> T
    {
        objc_sync_enter(lock)
        let retVal: T = closure()
        objc_sync_exit(lock)
        return retVal
    }
    
    static func clearConfig() {
        for key in preferences.dictionaryRepresentation().keys {
            preferences.removeObject(forKey: key.description)
        }
    }
    
    static func readAllConfig() {
        UserConfig.readConfig()
        AppConfig.readConfig()
    }
    
    static func saveAll() {
        UserConfig.save()
        AppConfig.save()
        preferences.synchronize()
    }
    
    static func updateAvailable() -> AvailableUpdates {
        let serverDBTS = AppConfig.getDatabaseTimestampServer()
        let appDBTS = UserConfig.getDatabaseTimestamp()
        if serverDBTS != nil {
            if (serverDBTS!) <= appDBTS {
                return .upToDate
            }
            return .available
        }
        return .notChecked
    }
    
}
