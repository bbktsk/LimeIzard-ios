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

    override func viewDidLoad() {
        super.viewDidLoad()

        let statusBar = UIView.loadFromNibNamed("StatusBar")!
        view.addSubview(statusBar)
        statusBar.snp_makeConstraints() { make in
            make.height.equalTo(44)
            make.bottom.equalTo(view.snp_bottom).offset(-49)
            make.left.right.equalTo(view)
        }
        self.statusBar = statusBar
    }

   

}
