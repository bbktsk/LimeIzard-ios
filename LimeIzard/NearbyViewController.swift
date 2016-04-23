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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: #selector(NearbyViewController.updateUsersNearby), name: UsersNearbyChanged, object: nil)
        
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    func updateUsersNearby() {
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
        }
    }
    


}

extension NearbyViewController : UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return UsersNearby.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCellWithIdentifier(nearbyCellIdentifier, forIndexPath: indexPath) as? NearbyViewCell {
            cell.loadFromUser(UsersNearby[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    

}

