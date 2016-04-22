//
//  Services.swift
//  LimeIzard
//
//  Created by Martin Vytrhlík on 22/04/16.
//  Copyright © 2016 LimeIzards. All rights reserved.
//

import Foundation
import KontaktSDK
import Alamofire
import SwiftyJSON

var BeaconManager: KTKBeaconManager!
let API = WebAPI._instance

func startRangingBeacons() {

    let proximityUUID = NSUUID(UUIDString: "11f10af9-8ec0-4e88-bc27-3fb17effe8bf")
    let region = KTKBeaconRegion(proximityUUID: proximityUUID!, identifier: "region-identifier")
    region.notifyEntryStateOnDisplay = true

    // Start Ranging
    BeaconManager.startRangingBeaconsInRegion(region)
    BeaconManager.startMonitoringForRegion(region)
    BeaconManager.requestStateForRegion(region)
}

class WebAPI {
    
    static let _instance = WebAPI()
    
    init() {
        
    }
    
    
    enum Router : URLRequestConvertible {
        
        static let baseURL = "https://lime-izard.herokuapp.com/api/"
        
        case UserInfo(userID: String)
        case UserUpdate(userID: String)
        case UserVisitBeacon(userID: String, beaconData: [String: AnyObject])
        
        
        var method : Alamofire.Method {
            switch self {
            case .UserInfo:
                return .GET
            case .UserUpdate:
                return .PUT
            case .UserVisitBeacon:
                return .POST
            }
        }
        
        var path : String {
            switch self {
            case .UserInfo(let userID):
                return "users/\(userID)"
            case .UserUpdate(let userID):
                return "users/\(userID)"
            case .UserVisitBeacon(let userID):
                return "users/\(userID)/visit"
            }
        }
        
        var URLRequest : NSMutableURLRequest {
            let URL = NSURL(string: Router.baseURL)!
            
            let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
            mutableURLRequest.HTTPMethod = method.rawValue
            mutableURLRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            mutableURLRequest.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
            
           
            
            switch self {
            case .UserVisitBeacon(_, let beaconData):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: beaconData).0
            default:
                return mutableURLRequest
            }
            
        }
        
    }
    
    func getUserInfo(userID: String, onComplete: (Int?, JSON?, NSError?) -> Void) {
        Alamofire.request(Router.UserInfo(userID: userID))
            .responseJSON { response in
                print("---------------------------")
                print(response.request)  // original URL request
                print(response.response) // URL response
                print(response.data)     // server data
                print(response.result)   // result of response serialization
                
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
        }
    }
    
    
    
    
}