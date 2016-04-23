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
import SVProgressHUD

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    private weak var loginButton: FBSDKLoginButton!
    
    override func loadView() {
        super.loadView()
        
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile", "email"]
        view.addSubview(loginButton)
        loginButton.snp_makeConstraints() {make in
            make.bottom.equalTo(view).offset(-15)
            make.left.equalTo(view).offset(10)
            make.right.equalTo(view).offset(-10)
            make.height.equalTo(44)
        }
        self.loginButton = loginButton
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.delegate = self
        
        
        if let token = FBSDKAccessToken.currentAccessToken()  {
            FBToken = token
            getUserData()
        }
        
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        FBToken = FBSDKAccessToken.currentAccessToken()
        getUserData()
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("you have logged out")
    }
    
    func getUserData() {
        if let tokenString = FBToken?.tokenString {
            SVProgressHUD.setDefaultStyle(.Dark)
            SVProgressHUD.show()
            let req = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"email,name"], tokenString: tokenString, version: nil, HTTPMethod: "GET")
            req.startWithCompletionHandler({ (connection, result, error : NSError!) -> Void in
                
                if(result != nil)
                {
                    
                    print("fejsbuuuk!")
                    let fbID = result.valueForKey("id") as? String
                    let fbName = result.valueForKey("name") as? String
                    
                    CurrentUser = User(fbID: fbID, fbName: fbName)
                    self.prepareForSeque()
                    SVProgressHUD.showSuccessWithStatus("CONNECTED")
                }
                else {
                    
                    SVProgressHUD.showErrorWithStatus("Connection FAILED")
                    print("error \(error)")
                }
            })
        }
    }
    
    func prepareForSeque() {
        
        dispatch_async(dispatch_get_main_queue()) {
            self.startTheGame()
        }
    }
    
    
    func startTheGame() {
        performSegueWithIdentifier("startTheGame", sender: self)
    }

}
