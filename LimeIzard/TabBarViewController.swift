//
//  TabBarViewController.swift
//  LimeIzard
//
//  Created by Martin Vytrhlík on 22/04/16.
//  Copyright © 2016 LimeIzards. All rights reserved.
//

import UIKit
import SnapKit

class TabBarViewController: UITabBarController {
    
    weak var statusBar: UIView!
    weak var availableButton: UIButton!
    weak var taglineButton: UIButton!
    var available = false
    
    override func loadView() {
        super.loadView()
        
        let statusBar = UIView()
        view.addSubview(statusBar)
        statusBar.snp_makeConstraints() { make in
            make.height.equalTo(44)
            make.bottom.equalTo(view.snp_bottom).offset(-50)
            make.left.right.equalTo(view)
        }
        self.statusBar = statusBar
        
        
        let availableButton = UIButton()
        availableButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        statusBar.addSubview(availableButton)
        availableButton.snp_makeConstraints() {make in
            make.left.equalTo(statusBar.snp_left).offset(5)
            make.width.equalTo(150)
            make.height.equalTo(30)
            make.centerY.equalTo(statusBar.snp_centerY)
        }
        self.availableButton = availableButton
        availableButton.imageEdgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
        
        let taglineButton = UIButton()
        taglineButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        statusBar.addSubview(taglineButton)
        taglineButton.snp_makeConstraints() {make in
            make.left.equalTo(availableButton.snp_right).offset(10)
            make.width.equalTo(150)
            make.height.equalTo(30)
            make.centerY.equalTo(statusBar.snp_centerY)
        }
        self.taglineButton = taglineButton
        
        let separator = UIView()
        separator.backgroundColor = UIColor.lightGrayColor()
        statusBar.addSubview(separator)
        separator.snp_makeConstraints() { make in
            make.height.equalTo(0.5)
            make.bottom.equalTo(statusBar.snp_top)
            make.left.right.equalTo(statusBar)
        }
    
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setAvailability(false)
        
        let image = UIImage(named: "first") as UIImage!
        availableButton.setImage(image, forState: .Normal)
        availableButton.addTarget(self, action: #selector(TabBarViewController.changeAvailability), forControlEvents: .TouchUpInside)
        
        taglineButton.addTarget(self, action: #selector(TabBarViewController.changeTagline), forControlEvents: .TouchUpInside)
        taglineButton.setTitle("happy", forState: .Normal)
    }

   
    func showAlert() {
    
    
    }
    
    func setAvailability(available: Bool) {
        self.available = available
        if available {
            let image = UIImage(named: "first") as UIImage!
            availableButton.setImage(image, forState: .Normal)
            availableButton.setTitle("available", forState: .Normal)
        } else {
            let image = UIImage(named: "second") as UIImage!
            availableButton.setImage(image, forState: .Normal)
            availableButton.setTitle("nope", forState: .Normal)
        }
    }
    
    func changeAvailability() {
        setAvailability(!available)
    }
    
    
    
    func changeTagline() {
        
        
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .ActionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("File Deleted")
        })
        let saveAction = UIAlertAction(title: "Save", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            print("File Saved")
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        
        //self.presentViewController(optionMenu, animated: true, completion: nil)
        
        
    }

}
