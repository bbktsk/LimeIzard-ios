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
    
    weak var statusBar: StatusBar!

    override func viewDidLoad() {
        super.viewDidLoad()

        let statusBar = UIView.loadFromNibNamed("StatusBar") as! StatusBar
        view.addSubview(statusBar)
        statusBar.snp_makeConstraints() { make in
            make.height.equalTo(44)
            make.bottom.equalTo(view.snp_bottom).offset(-50)
            make.left.right.equalTo(view)
        }
        
        let image = UIImage(named: "first") as UIImage!
        statusBar.availableButton.setImage(image, forState: .Normal)
        
        self.statusBar = statusBar
        
        let separator = UIView()
        separator.backgroundColor = UIColor.lightGrayColor()
        statusBar.addSubview(separator)
        separator.snp_makeConstraints() { make in
            make.height.equalTo(0.5)
            make.bottom.equalTo(statusBar.snp_top)
            make.left.right.equalTo(statusBar)
        }
        statusBar.availableButton.imageEdgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
    }

   
    func showAlert() {
    
    
    }

}
