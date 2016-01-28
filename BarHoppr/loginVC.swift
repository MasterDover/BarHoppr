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

    @IBOutlet weak var profileImage: UIImageView!
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
            
            
            let fbRequest = FBSDKGraphRequest(graphPath:"me", parameters: ["fields": "email, id, first_name, last_name, name, friends, birthday, picture.type(large)"]);
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
                    InfoList.append(result.valueForKey("picture")!)
                    print(InfoList)
                    userProfile.email = InfoList[0] as! String
                    userProfile.userID = InfoList[1] as! String
                    userProfile.fname = InfoList[2] as! String
                    userProfile.lname = InfoList[3] as! String
                    userProfile.fullName = InfoList[4] as! String
                    userProfile.birthday = InfoList[5] as! String
                    userProfile.friendList = InfoList[6] as! [NSDictionary]
                    
                    
                    var query = PFQuery(className: "AppUsers")
                    query.whereKey("userID", equalTo: InfoList[1])
                    query.findObjectsInBackgroundWithBlock{ (objects: [PFObject]?, error: NSError?) -> Void in
                        
                        if error == nil {
                            
                                if objects!.isEmpty
                                {
                                    
                                    
                                    var profile = PFObject(className: "AppUsers")
                                    profile.setObject(InfoList[0], forKey: "email")
                                    profile.setObject(InfoList[2], forKey: "fname")
                                    profile.setObject(InfoList[3], forKey: "lname")
                                    profile.setObject(InfoList[4], forKey: "fullName")
                                    profile.setObject(InfoList[5], forKey: "birthday")
                                    profile.setObject(InfoList[1], forKey: "userID")
                                    profile.setObject(InfoList[6], forKey: "friends")
                                    profile.saveInBackgroundWithBlock{
                                        (success: Bool, error: NSError?) -> Void in
                                        if (success) {
                                            // The object has been saved.
                                            
                                            Singleton.defaults.setValue(profile.objectId, forKey: "parseID")
                                            
                                        } else {
                                            // There was a problem, check error.description
                                        }
                                        
                                    }
                                    
                                } else {
                                    var query2 = PFQuery(className: "AppUsers")
                                    query.getObjectInBackgroundWithId(objects!.first!.objectId!)
                                        {
                                            (profile: PFObject?, error: NSError?) -> Void in
                                            if error != nil {
                                                print(error)
                                            } else if let profile = profile {
                                                profile.setObject(InfoList[0], forKey: "email")
                                                profile.setObject(InfoList[2], forKey: "fname")
                                                profile.setObject(InfoList[3], forKey: "lname")
                                                profile.setObject(InfoList[4], forKey: "fullName")
                                                profile.setObject(InfoList[5], forKey: "birthday")
                                                profile.setObject(InfoList[1], forKey: "userID")
                                                profile.setObject(InfoList[6], forKey: "friends")
                                                profile.saveInBackgroundWithBlock{
                                                    (success: Bool, error: NSError?) -> Void in
                                                    if (success) {
                                                        // The object has been saved.
                                                        Singleton.defaults.setValue(profile.objectId, forKey: "parseID")
                                                        
                                                    } else {
                                                        // There was a problem, check error.description
                                                    }
                                                }
                                            }
                                    }
                                    
                                }
                            }
                        }
                    
                    
                    var picURL = NSURL(string: InfoList[7].valueForKey("data")!.valueForKey("url") as! String)
                    let data = NSData(contentsOfURL: picURL!)
                    self.profileImage.image = UIImage(data: data!)
                    
                    
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
