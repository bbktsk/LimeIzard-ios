//
//  ProfileViewController.swift
//  LimeIzard
//
//  Created by Pavel Hamrik on 22/04/16.
//  Copyright © 2016 LimeIzards. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var profile = [
        [
            "Name": "Martin",
            "Gender": "Male"
        ],
        [
            "Label": "Value"
        ]
    ]
    
    let profileSections = [
        "You",
        "Other"
    ]

    @IBOutlet weak var tableView: UITableView!
    
    let profileCellIdentifier = "ProfileCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


}


extension ProfileViewController : UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profile.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCellWithIdentifier(profileCellIdentifier, forIndexPath: indexPath) as? ProfileCell {
            //cell.preferenceLabel?.text = profile[indexPath.section][indexPath.row]
            
            return cell
        }
        return UITableViewCell()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return profile.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return profileSections[section]
    }
    
    
    
}