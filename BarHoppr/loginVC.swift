//
//  loginVC.swift
//  BarHoppr
//
//  Created by csc313 on 1/24/16.
//  Copyright © 2016 CD Studios. All rights reserved.
//


import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Parse


class loginVC: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var loginButton: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if(FBSDKAccessToken.currentAccessToken() == nil)
        {
            print("User not logged in")
            
        } else
        {
            print("user Logged in")
        }
        
        loginButton.delegate = self
        loginButton.readPermissions = ["public_profile","email","user_friends"]
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!)
    {
        if let userToken = result.token
        {
            let token:FBSDKAccessToken = result.token
            
            
            let fbRequest = FBSDKGraphRequest(graphPath:"me", parameters: ["fields": "email"]);
            fbRequest.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
                
                if error == nil {
                
                    print("Friends are : \(result.valueForKey("email")!)")
                
                } else {
                    
                    print("Error Getting Friends \(error)");
                    
                }
            }
            
            
            //let newScreen:loginVC = loginVC()
            //self.presentViewController(newScreen, animated: true, completion: nil)
        }
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!)
    {
        print("logged out")
    }

}
