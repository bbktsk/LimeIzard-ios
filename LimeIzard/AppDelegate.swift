//
//  AppDelegate.swift
//  LimeIzard
//
//  Created by Pavel Hamrik on 22/04/16.
//  Copyright © 2016 LimeIzards. All rights reserved.
//

import UIKit
import KontaktSDK
import FBSDKLoginKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var beaconManager: KTKBeaconManager!
    

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        //facebook
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)

        //iBeacon
        let beacon = KTKBeaconManager(delegate: self)
        BeaconManager = beacon

        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        
        FBSDKAppEvents.activateApp()
        
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)

    }
}




extension AppDelegate: KTKBeaconManagerDelegate {
    
    func beaconManager(manager: KTKBeaconManager, didDetermineState state: CLRegionState, forRegion region: KTKBeaconRegion) {
        print("Did determine state \"\(state.rawValue)\" for region: \(region)")
    }
    
    func beaconManager(manager: KTKBeaconManager, didChangeLocationAuthorizationStatus status: CLAuthorizationStatus) {
        print("Did change location authorization status to: \(status.rawValue)")
    }
    
    func beaconManager(manager: KTKBeaconManager, monitoringDidFailForRegion region: KTKBeaconRegion?, withError error: NSError?) {
        print("Monitoring did fail for region: \(region)")
        print("Error: \(error)")
    }
    
    func beaconManager(manager: KTKBeaconManager, didStartMonitoringForRegion region: KTKBeaconRegion) {
        print("Did start monitoring for region: \(region)")
    }
    
    func beaconManager(manager: KTKBeaconManager, didEnterRegion region: KTKBeaconRegion) {
        print("Did enter region: \(region)")
    }
    
    func beaconManager(manager: KTKBeaconManager, didExitRegion region: KTKBeaconRegion) {
        print("Did exit region \(region)")
    }
    
    func beaconManager(manager: KTKBeaconManager, didRangeBeacons beacons: [CLBeacon], inRegion region: KTKBeaconRegion) {
        print("Did ranged \"\(beacons.count)\" beacons inside region: \(region)")
        
        if let closestBeacon = beacons.sort({ $0.0.accuracy <= $0.1.accuracy }).first where closestBeacon.accuracy > 0 {
            let identifier = "\(closestBeacon.proximityUUID.UUIDString)|\(closestBeacon.major)|\(closestBeacon.minor)"
           
            var beaconData = [String : AnyObject]()
            beaconData.updateValue(closestBeacon.rssi, forKey: "signal")
            beaconData.updateValue(identifier, forKey: "beacon_uuid")
            beaconData.updateValue(0, forKey: "longitude")
            beaconData.updateValue(0, forKey: "latitude")
            print(identifier)
            API.sendUserVisitBeacon(CurrentUser?.fbID ?? "0", beaconData: beaconData)
            
            NSNotificationCenter.defaultCenter().postNotificationName("nearbyIndicatorUpdateNotification", object: nil, userInfo:["accuracy": closestBeacon.accuracy, "proximity": closestBeacon.proximity.rawValue])
            
        }
    }
}