//
//  LoginViewController.swift
//  LimeIzard
//
//  Created by Martin Vytrhlík on 23/04/16.
//  Copyright © 2016 LimeIzards. All rights reserved.
//

import SnapKit
import FBSDKCoreKit
import FBSDKLoginKit

class LoginViewController: UIViewController {

    private weak var loginButton: FBSDKLoginButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let loginButton = FBSDKLoginButton()
        view.addSubview(loginButton)
        loginButton.snp_makeConstraints() {make in
            make.bottom.equalTo(view).offset(-15)
            make.left.equalTo(view).offset(10)
            make.right.equalTo(view).offset(-10)
            make.height.equalTo(44)
        }
        self.loginButton = loginButton
        
        
    }
    
    

}
