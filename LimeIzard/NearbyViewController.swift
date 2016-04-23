//
//  NearbyViewController.swift
//  LimeIzard
//
//  Created by Martin Vytrhlík on 22/04/16.
//  Copyright © 2016 LimeIzards. All rights reserved.
//

import UIKit

class NearbyViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let nearbyCellIdentifier = "NearbyCell"
    var nearbyTimer: NSTimer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: #selector(NearbyViewController.updateUsersNearby), name: UsersNearbyChanged, object: nil)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func startChecking() {
        var nearbyTimer = NSTimer()
        nearbyTimer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(NearbyViewController.checkForNearbyUsers), userInfo: nil, repeats: true)
        self.nearbyTimer = nearbyTimer
    }
    
    func stopChecking() {
        nearbyTimer?.invalidate()
    }
    
    func checkForNearbyUsers() {
        
    }
    
    func updateUsersNearby() {
        
    }


}

extension NearbyViewController : UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCellWithIdentifier(nearbyCellIdentifier, forIndexPath: indexPath) as? NearbyViewCell {
            return cell
        }
        return UITableViewCell()
    }
    

}

