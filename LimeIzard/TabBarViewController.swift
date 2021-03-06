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
    
    @IBOutlet weak var nearbyIndicator: UIBarButtonItem!
    
    weak var statusBar: UIView!
    weak var availableButton: UIButton!
    weak var taglineButton: UIButton!
    var available = false
    var nearbyTimer: NSTimer?
    
    weak var warningViewBGView: UIView!
    weak var warningViewTextLabel: UILabel!
    var warningViewShowed = false

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
        
        let vSeparator = UIView()
        vSeparator.backgroundColor = UIColor.lightGrayColor()
        statusBar.addSubview(vSeparator)
        vSeparator.snp_makeConstraints() { make in
            make.width.equalTo(0.5)
            make.bottom.equalTo(statusBar.snp_bottom)
            make.top.equalTo(statusBar.snp_top)
            make.left.equalTo(130)
        }
        
        createWarningView()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TabBarViewController.nearbyIndicatorUpdate(_:)), name:"nearbyIndicatorUpdateNotification", object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TabBarViewController.showWarningMessage(_:)), name:"PokeReceived", object: nil)
    
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setAvailability(true)
        
        //let image = UIImage(named: "first") as UIImage!
        //availableButton.setImage(image, forState: .Normal)
        availableButton.addTarget(self, action: #selector(TabBarViewController.changeAvailability), forControlEvents: .TouchUpInside)
        
        taglineButton.addTarget(self, action: #selector(TabBarViewController.changeTagline), forControlEvents: .TouchUpInside)
        taglineButton.setTitle(feelings["happy"], forState: .Normal)
        
        
        var nearbyTimer = NSTimer()
        nearbyTimer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(TabBarViewController.checkForNearbyUsers), userInfo: nil, repeats: true)
        self.nearbyTimer = nearbyTimer
        checkForNearbyUsers()
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
    
    func nearbyIndicatorUpdate(notification: NSNotification) {
        
        let userinfo = notification.userInfo
        if userinfo?["proximity"] != nil {
            let proximity = userinfo?["proximity"] as! Int
            switch proximity {
            case 0:
                nearbyIndicator.image = UIImage(named: "nearby-1") as UIImage!
            case 1:
                nearbyIndicator.image = UIImage(named: "nearby-4") as UIImage!
            case 2:
                nearbyIndicator.image = UIImage(named: "nearby-3") as UIImage!
            case 3:
                nearbyIndicator.image = UIImage(named: "nearby-2") as UIImage!
            default:
                nearbyIndicator.image = UIImage(named: "nearby-1") as UIImage!
            }
            print("proximity update: \(proximity)")
        }
    
    }
    
    func showWarningMessage(notification: NSNotification) {
        
        let userinfo = notification.userInfo
        if userinfo?["name"] != nil {
            let name = userinfo?["name"] as! String
            warningViewTextLabel.text = "\(name) just poked you!"
            if !warningViewShowed {
                var deltaY = self.warningViewBGView.frame.height + 71
                UIView.animateKeyframesWithDuration(3 , delay: 0, options: UIViewKeyframeAnimationOptions(), animations: {
                    UIView.addKeyframeWithRelativeStartTime(0,
                        relativeDuration: 0.05,
                        animations: {
                            self.warningViewShowed = true
                            self.warningViewBGView.frame.origin.y += deltaY
                    })
                    UIView.addKeyframeWithRelativeStartTime(0.95,
                        relativeDuration: 0.05,
                        animations: {
                            self.warningViewBGView.frame.origin.y -= deltaY
                    })
                    }, completion: { finished in
                        self.warningViewShowed = false
                })
            }
        }
    }
    
    
    func createWarningView() {
        
        let warningViewBGView = UIView()
        warningViewBGView.backgroundColor = UIColor.redColor()
        self.view.addSubview(warningViewBGView)
        warningViewBGView.snp_makeConstraints() { make in
            make.left.equalTo(self.view).offset(1)
            make.right.equalTo(self.view).inset(1)
            make.height.equalTo(45)
            make.bottom.equalTo(self.view.snp_top)
        }
        self.warningViewBGView = warningViewBGView
        
        let warningViewTextLabel = UILabel()
        warningViewTextLabel.font = UIFont.boldSystemFontOfSize(20)
        warningViewTextLabel.textColor = .whiteColor()
        warningViewTextLabel.textAlignment = .Center
        warningViewTextLabel.adjustsFontSizeToFitWidth = true
        warningViewTextLabel.minimumScaleFactor = 0.5
        warningViewBGView.addSubview(warningViewTextLabel)
        warningViewTextLabel.snp_makeConstraints() { make in
            make.edges.equalTo(warningViewBGView).inset(3)
        }
        self.warningViewTextLabel = warningViewTextLabel
    }
    
    func checkForNearbyUsers() {
        API.getPokes()
        startRangingBeacons()
        BeaconManager.requestStateForRegion(MyRegion)
        BeaconManager.requestLocationAlwaysAuthorization()
//        var timer = NSTimer()
//        timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(TabBarViewController.stopChecking), userInfo: nil, repeats: false)
    }
    
//    func stopChecking() {
//        BeaconManager.stopMonitoringForAllRegions()
//    }
}
