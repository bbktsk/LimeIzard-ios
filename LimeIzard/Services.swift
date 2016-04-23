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
import FBSDKLoginKit

struct User {
    var fbID: String
    var fbName: String
    var firstName: String?
    var lastName: String?
    var imgUrl: String?
    var mood: String = ""
    var message: String = ""
    var signal: Float = 0
}

var BeaconManager: KTKBeaconManager!
let API = WebAPI._instance
var FBToken: FBSDKAccessToken?
var CurrentUser: User?
var usersNearby = [User]()
let UsersNearbyChanged = "UsersNearbyChanged"

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
        case UserCreate(user: [String: AnyObject])
        
        var method : Alamofire.Method {
            switch self {
            case .UserInfo:
                return .GET
            case .UserUpdate:
                return .PUT
            case .UserCreate :
                return .POST
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
            case .UserCreate:
                return "users"
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
            case .UserCreate(let user):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: user).0
            case .UserVisitBeacon(_, let beaconData):
                return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: beaconData).0
            default:
                return mutableURLRequest
            }
            
        }
        
    }
    
    func getUserInfo(userID: String, onComplete: ([String: AnyObject]?, NSError?) -> Void) {
        Alamofire.request(Router.UserInfo(userID: userID))
            .responseJSON { response in
                print("---------------------------")
                print(response.request)  // original URL request
                print(response.result)   // result of response serialization
                
                
                if let json = response.result.value as? [String: AnyObject] {
                    print(NSString(data: response.data!, encoding:NSUTF8StringEncoding)!)
                    onComplete(json, nil)
                }
                else {
                    print("no user data found")
                    onComplete(nil,nil)
                }
        }
    }
    
    
    func createUser(user: [String: AnyObject], onComplete: (JSON?, NSError?) -> Void) {
        Alamofire.request(Router.UserCreate(user: user))
            .responseJSON { response in
                print("---------------------------")
                print(response.request)  // original URL request
                
                print(NSString(data: response.request!.HTTPBody!, encoding:NSUTF8StringEncoding)!)
                print(response.result)   // result of response serialization
                
                let json = response.result.value as? JSON
                print(json)
                onComplete(json, nil)
        }
    }
    
    func sendUserVisitBeacon(userID: String, beaconData: [String: AnyObject], onComplete: [String: AnyObject]? -> Void) {
        Alamofire.request(Router.UserVisitBeacon(userID: userID, beaconData: beaconData))
            .responseJSON { response in
                print("---------------------------")
                print(response.request)  // original URL request
                print(NSString(data: response.request!.HTTPBody!, encoding:NSUTF8StringEncoding)!)
                
                usersNearby.removeAll()
                if let data = response.result.value as? [String: AnyObject] {
                    
                    if let people = data["people"] as? [AnyObject] {
                        for p in people {
                            let name = p["first_name"] as? String ?? "---"
                            let signal = p["signal"] as? Float ?? 0
                            let mood = p["mood"] as? String ?? ""
                            let message = p["message"] as? String ?? ""
                            let imgUrl = p["photo_url"] as? String ?? ""
                            let usr = User(fbID: "", fbName: "", firstName: name, lastName: "", imgUrl: imgUrl, mood: mood, message: message, signal: signal)
                            usersNearby.append(usr)
                            print("adding user \(name)")
                        }
                    }
                }
                else {
                    
                }
                
                let nc = NSNotificationCenter.defaultCenter()
                nc.postNotificationName(UsersNearbyChanged, object: nil)
        }
    }
    
    
}