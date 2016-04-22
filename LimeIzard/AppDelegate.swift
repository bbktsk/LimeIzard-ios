//
//  AppDelegate.swift
//  LimeIzard
//
//  Created by Pavel Hamrik on 22/04/16.
//  Copyright © 2016 LimeIzards. All rights reserved.
//

import UIKit
import KontaktSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        BeaconManager = KTKBeaconManager()
        BeaconManager.delegate = self
        BeaconManager.requestLocationAlwaysAuthorization()
        let uid = NSUUID(UUIDString: "11f10af9-8ec0-4e88-bc27-3fb17effe8bf")
        let region = KTKBeaconRegion(proximityUUID: uid!, identifier: "")
        BeaconManager.startMonitoringForRegion(region)
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
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
        
        if let closestBeacon = beacons.sort({ $0.0.accuracy < $0.1.accuracy }).first where closestBeacon.accuracy > 0 {
            print("Closest Beacon is M: \(closestBeacon.major), m: \(closestBeacon.minor) ~ \(closestBeacon.accuracy) meters away.")
        }
    }
}

