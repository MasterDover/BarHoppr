//
//  userProfile.swift
//  BarHoppr
//
//  Created by Curcio, Joshua M on 1/26/16.
//  Copyright © 2016 CD Studios. All rights reserved.
//

import UIKit
import CoreLocation
import Parse

class userProfile: NSObject {
    
    static var username = ""
    static var email = ""
    static var fname = ""
    static var lname = ""
    static var fullName = ""
    static var birthday = ""
    static var friendList = [NSDictionary]()
    static var location = PFGeoPoint()
    static var userID = ""
    

}
