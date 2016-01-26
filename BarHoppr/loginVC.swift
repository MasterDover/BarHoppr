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
        loginButton.readPermissions = ["public_profile","email","user_friends","user_birthday"]
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!)
    {
        var InfoList = [AnyObject]()
        
        if let userToken = result.token
        {
            let token:FBSDKAccessToken = result.token
            
            
            let fbRequest = FBSDKGraphRequest(graphPath:"me", parameters: ["fields": "email, id, first_name, last_name, name, friends, birthday"]);
            fbRequest.startWithCompletionHandler { (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
                
                if error == nil {
                    
                    InfoList.append(result.valueForKey("email")!)
                    InfoList.append(result.valueForKey("id")!)
                    InfoList.append(result.valueForKey("first_name")!)
                    InfoList.append(result.valueForKey("last_name")!)
                    InfoList.append(result.valueForKey("name")!)
                    InfoList.append(result.valueForKey("birthday")!)
                    
                    var test = result.valueForKey("friends") as! NSDictionary
                    var friendArray = test.valueForKey("data") as! [NSDictionary]
                    
                    InfoList.append(friendArray)
                
                } else {
                    
                    print("Error Getting Info \(error)");
                }
            }
            let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
            let vc : UIViewController = mainStoryboard.instantiateViewControllerWithIdentifier("MainVC") as UIViewController
            self.presentViewController(vc, animated: true, completion: nil)
        }
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!)
    {
        print("logged out")
    }

}
