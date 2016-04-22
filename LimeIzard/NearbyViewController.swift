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

