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
    

    let feelings = [
        "happy": "\u{1F600} Happy",
        "cheerful": "\u{1F60A} Cheerful",
        "thinking": "\u{1F914} Thinking",
        "custom": "\u{1F4AC} Custom"
    ]

    let availabilities = [
        "available": "\u{1F917} Available",
        "sleeping": "\u{1F634} Sleeping"
    ]

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
        availableButton.setTitleColor(UIColor(hex: 0x43de0a), forState: .Normal)
        statusBar.addSubview(availableButton)
        availableButton.snp_makeConstraints() {make in
            make.left.equalTo(statusBar.snp_left).offset(15)
            make.width.equalTo(120)
            make.height.equalTo(42)
            make.centerY.equalTo(statusBar.snp_centerY)
        }
        availableButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        self.availableButton = availableButton
        //availableButton.imageEdgeInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        
        let taglineButton = UIButton()
        taglineButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        statusBar.addSubview(taglineButton)
        taglineButton.snp_makeConstraints() {make in
            make.left.equalTo(availableButton.snp_right).offset(10)
            make.right.equalTo(statusBar.snp_right)
            make.height.equalTo(42)
            make.centerY.equalTo(statusBar.snp_centerY)
        }
        taglineButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        taglineButton.titleLabel?.lineBreakMode = .ByTruncatingTail
        self.taglineButton = taglineButton
        
        let separator = UIView()
        separator.backgroundColor = UIColor.lightGrayColor()
        statusBar.addSubview(separator)
        separator.snp_makeConstraints() { make in
            make.height.equalTo(0.5)
            make.bottom.equalTo(statusBar.snp_top)
            make.left.right.equalTo(statusBar)
        }
        statusBar.backgroundColor = UIColor.whiteColor()
    
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setAvailability(true)
        
        //let image = UIImage(named: "first") as UIImage!
        //availableButton.setImage(image, forState: .Normal)
        availableButton.addTarget(self, action: #selector(TabBarViewController.changeAvailability), forControlEvents: .TouchUpInside)
        
        taglineButton.addTarget(self, action: #selector(TabBarViewController.changeTagline), forControlEvents: .TouchUpInside)
        taglineButton.setTitle(feelings["happy"], forState: .Normal)
    }

   
    func showAlert() {
    
    
    }
    
    func setAvailability(available: Bool) {
        self.available = available
        if available {
            availableButton.setTitle(availabilities["available"], forState: .Normal)
            availableButton.setTitleColor(UIColor(hex: 0x43de0a), forState: .Normal)
        } else {
            availableButton.setTitle(availabilities["sleeping"], forState: .Normal)
            availableButton.setTitleColor(UIColor(hex: 0xdd0b38), forState: .Normal)
        }
    }
    
    func changeAvailability() {
        setAvailability(!available)
    }
    
    
    
    func changeTagline() {
        
        
        let optionMenu = UIAlertController(title: nil, message: "How Are You Feeling?", preferredStyle: .ActionSheet)
        
        let happyAction = UIAlertAction(title: feelings["happy"], style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.taglineButton.setTitle(self.feelings["happy"], forState: .Normal)
        })
        let cheerfulAction = UIAlertAction(title: feelings["cheerful"], style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.taglineButton.setTitle(self.feelings["cheerful"], forState: .Normal)
        })

        let thinkingAction = UIAlertAction(title: feelings["thinking"], style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.taglineButton.setTitle(self.feelings["thinking"], forState: .Normal)
        })

        let customAction = UIAlertAction(title: feelings["custom"], style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.composeTagline()
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            print("Cancelled")
        })
        
        optionMenu.addAction(happyAction)
        optionMenu.addAction(cheerfulAction)
        optionMenu.addAction(thinkingAction)
        optionMenu.addAction(customAction)
        optionMenu.addAction(cancelAction)
        
        self.presentViewController(optionMenu, animated: true, completion: nil)


    }

    func composeTagline() {


        let composeAlert = UIAlertController(title: "Customize", message: "You're feeling...", preferredStyle: .Alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            let loginTextField = composeAlert.textFields![0] as UITextField
            if (loginTextField.text ?? "").isEmpty {
                self.taglineButton.setTitle("\u{1F4AC} Unsure. Probably.", forState: .Normal)
            }
            else {
                self.taglineButton.setTitle("\u{1F4AC} " + loginTextField.text!, forState: .Normal)
            }

        })

        composeAlert.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Chatty, maybe?"
            textField.autocapitalizationType = .Sentences
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })

        composeAlert.addAction(confirmAction)
        composeAlert.addAction(cancelAction)
        composeAlert.preferredAction = confirmAction

        self.presentViewController(composeAlert, animated: true, completion: nil)
        
    }


}
