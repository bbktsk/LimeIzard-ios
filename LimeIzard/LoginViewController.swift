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
            make.bottom.equalTo(view).offset(-90)
            make.left.equalTo(view).offset(15)
            make.right.equalTo(view).offset(-15)
            make.height.equalTo(50)
        }
        self.loginButton = loginButton
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.delegate = self
        
        
        if let token = FBSDKAccessToken.currentAccessToken()  {
            FBToken = token
            getUserFBData()
            checkOrCreateUser()
        }
        
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        FBToken = FBSDKAccessToken.currentAccessToken()
        getUserFBData()
        checkOrCreateUser()
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("you have logged out")
    }
    
    func getUserFBData() {
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
                    
                    CurrentUser = User(fbID: fbID ?? "0", fbName: fbName ?? "noname", firstName: "", lastName: "", imgUrl: nil, mood: "", message: "", signal: 0)
                    
                    SVProgressHUD.showSuccessWithStatus("CONNECTED")
                    self.checkOrCreateUser()
                }
                else {
                    
                    SVProgressHUD.showErrorWithStatus("Connection FAILED")
                    print("error \(error)")
                }
            })
        }
    }
    
    
    func checkOrCreateUser() {
        if let usr = CurrentUser {
            API.getUserInfo(usr.fbID) { (data, error) in
                
                if let data = data {
                    print("succ")
                    self.prepareForSeque()
                }
                else {
                    print("creating user")
                    self.createUser()
                }
                
            }
        }
        
    }
    
    func createUser() {
        if let usr = CurrentUser {
            var userData = [String: AnyObject]()
            var firstName = ""
            var lastName = ""
            
            let range = usr.fbName.rangeOfString(" ")
            if let range = range {
                
                firstName = usr.fbName.substringToIndex(range.endIndex).stringByReplacingOccurrencesOfString(" ", withString: "")
                lastName = usr.fbName.substringFromIndex(range.endIndex)
            }
            else {
                firstName = usr.fbName
            }
            let ide = usr.fbID
            userData.updateValue(usr.fbID, forKey: "fb_id")
            userData.updateValue(firstName, forKey: "first_name")
            userData.updateValue(lastName, forKey: "last_name")
            
            API.createUser(userData) { (json, error) in
                
                if let json = json{
                    print("jo")
                }
                self.prepareForSeque()
            }
        }
    }
    
    func prepareForSeque() {
        
        dispatch_async(dispatch_get_main_queue()) {
            self.startTheGame()
        }
    }
    
    
    func startTheGame() {
        BeaconManager.requestLocationAlwaysAuthorization()
        startRangingBeacons()
        performSegueWithIdentifier("startTheGame", sender: self)
    }

}
