//
//  ResponseHandler.swift
//  Hausa
//
//  Created by Emre Can Bolat on 14.01.18.
//  Copyright © 2018 MNM Team. All rights reserved.
//

import Foundation

class ResponseHandler {

    let updateDatabase = UpdateDatabase()
    
    private func identifyPackage(_ response: JSONObject) -> HNObject? {
        let object: HNObject
        
        switch response.getInt(name: "constructor")! {
        case HN_receivedDatabaseDate.constructor:
            object = HN_receivedDatabaseDate()
            break
        case HN_updatedEntries.constructor:
            object = HN_updatedEntries()
            break
        default:
            return nil
        }

        object.readParams(object: response.getArray(name: "message")?.values[0] as! JSONObject)
        return object
    }
    
    func handleMessage(_ response: JSONObject) {
        let object = identifyPackage(response)

        if let object = object as? HN_receivedDatabaseDate {
            handleDatabaseDate(object)
        } else if let object = object as? HN_updatedEntries {
            handleUpdatedEntries(object, response.getInt(name: "timestamp")!)
        }
    }
    
    private func handleDatabaseDate(_ object: HN_receivedDatabaseDate){
        let databaseDate = object.date
        AppConfig.setDatabaseTimestampServer(databaseDate!)
        AppConfig.setLastCheckedDBTimestampServer(Date().toInt())
        NotificationCenter.default.post(name: .gotDBTime, object: nil)
        NotificationCenter.default.post(name: .updateState, object: nil)
    }
    
    private func handleUpdatedEntries(_ object: HN_updatedEntries, _ timestamp: Int){
        updateDatabase.handleMediaEntriesUpdate(object.mediaEntries) { () in
            for item in object.categories {
                self.updateDatabase.handleCategoryUpdate(item)
            }
            
            for item in object.englishEntries {
                self.updateDatabase.handleEnglishEntryUpdate(item)
            }
            
            for item in object.hausaEntries {
                self.updateDatabase.handleHausaEntryUpdate(item)
            }
            
            for item in object.entries {
                self.updateDatabase.handleEntryUpdate(item)
            }
            
            for item in object.entryCategories {
                self.updateDatabase.handleEntryCategoriesUpdate(item)
            }
            
            for item in object.entryMedias {
                self.updateDatabase.handleEntryMediaUpdate(item)
            }
            
            UserConfig.setDatabaseTimestamp(timestamp: timestamp)
            AppConfig.setDatabaseTimestampServer(timestamp)
            
            NotificationCenter.default.post(name: .gotDBTime, object: nil)
            ScreenManager.instance.update()
            return nil
        }
    }
    
}
