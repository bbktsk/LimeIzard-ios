//
//  StatusBar.swift
//  LimeIzard
//
//  Created by Pavel Hamrik on 22/04/16.
//  Copyright © 2016 LimeIzards. All rights reserved.
//

import UIKit
import SnapKit

class StatusBar: UIView {
    
    var available = false
    
    @IBOutlet weak var availableButton: UIButton!
    
 
    
    @IBAction func changeAvailability(sender: AnyObject) {
        
        if available {
            let image = UIImage(named: "first") as UIImage!
            sender.setImage(image, forState: .Normal)
        } else {
            let image = UIImage(named: "second") as UIImage!
            sender.setImage(image, forState: .Normal)
        }
        
        available = !available
        
    }
    
    
    
    @IBAction func changeTagline(sender: AnyObject) {
        
        
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


extension UIView {
    class func loadFromNibNamed(nibNamed: String, bundle : NSBundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? UIView
    }
}