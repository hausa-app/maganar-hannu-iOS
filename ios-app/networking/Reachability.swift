//
//  Reachability.swift
//  Hausa
//
//  Created by Emre Can Bolat on 12.01.18.
//  Copyright © 2018 MNM Team. All rights reserved.
//

import Foundation
import SystemConfiguration

enum ReachabilityType {
    case wwan
    case wiFi
}

enum ReachabilityStatus {
    
    case offline
    case online(ReachabilityType)
    case unknown
    
    init(reachabilityFlags flags: SCNetworkReachabilityFlags) {
        let connectionRequired = flags.contains(.connectionRequired)
        let isReachable = flags.contains(.reachable)
        let isWWAN = flags.contains(.isWWAN)
        
        if !connectionRequired && isReachable {
            if isWWAN {
                self = .online(.wwan)
            } else {
                self = .online(.wiFi)
            }
        } else {
            self =  .offline
        }
    }
}
