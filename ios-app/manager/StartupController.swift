//
//  StartupController.swift
//  Hausa
//
//  Created by Emre Can Bolat on 16.12.17.
//  Copyright © 2017 MNM Team. All rights reserved.
//

import UIKit

class StartupController {
    
    static let instance = StartupController()
    var dbInit: DatabaseInitializer = DatabaseInitializer()
    var networkManager = NetworkManager()
    
    func initializeApp() {
        self.dbInit.initTables()
        Config.saveAll()
    }
    
    func initialize() {
        AppConfig.readConfig()
        
    }
    
    func checkUpdate() {
        if UserConfig.isCheckForUpdatesOnStartup(){
            let status = networkManager.checkNetworkAvailability()
            switch status {
            case .online(.wiFi):
                networkManager.requestDateOfServerDB()
                break;
            default:
                break;
            }
            
        }
    }

}
