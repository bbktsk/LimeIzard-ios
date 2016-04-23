//
//  ProfileViewController.swift
//  LimeIzard
//
//  Created by Pavel Hamrik on 22/04/16.
//  Copyright © 2016 LimeIzards. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    // section / row / label+value
    var profile = [
        [
            ["label": "Name", "value": "Martin Vytrhlik"],
            ["label": "Gender", "value": "Male"]
        ],
        [
            ["label": "Conversations", "value": "12 last month. Great!"],
            ["label": "Mostly Feeling", "value": "\u{1F60A} Cheerful"]
        ]
    ]
    
    let profileSections = [
        "You",
        "Usage"
    ]

    @IBOutlet weak var tableView: UITableView!
    
    let profileCellIdentifier = "ProfileCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


}


extension ProfileViewController : UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profile[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCellWithIdentifier(profileCellIdentifier, forIndexPath: indexPath) as? ProfileCell {
            cell.profileRowLabel?.text = profile[indexPath.section][indexPath.row]["label"]
            cell.profileRowValue?.text = profile[indexPath.section][indexPath.row]["value"]
            
            return cell
        }
        return UITableViewCell()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return profileSections.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return profileSections[section]
    }
    
    
    
}