//
//  Services.swift
//  LimeIzard
//
//  Created by Martin Vytrhlík on 22/04/16.
//  Copyright © 2016 LimeIzards. All rights reserved.
//

import Foundation
import KontaktSDK

internal var BeaconManager: KTKBeaconManager!
internal let API:WebService = WebService._instance


class BeaconManagerClass : KTKBeaconManager {
    
    static let _istance = BeaconManagerClass()
    
    private let uuids = ["LimeIzard1" : "11f10af9-8ec0-4e88-bc27-3fb17effe8bf"]
    
    func startMonitoringForRegions() {
        for (name, uuid) in uuids {
            if let uid = NSUUID(UUIDString: uuid) {
                let region = KTKBeaconRegion(proximityUUID: uid, identifier: name)
                startMonitoringForRegion(region)
            }
        }
    }
    
    func stopMonitoringForRegions() {
        for (name, uuid) in uuids {
            if let uid = NSUUID(UUIDString: uuid) {
                let region = KTKBeaconRegion(proximityUUID: uid, identifier: name)
                stopMonitoringForRegion(region)
            }
        }
    }
    
}

class WebService {
    
    static let _instance: WebService = WebService()
    
    private init() {
        
    }
}
