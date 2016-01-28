//
//  MainVC.swift
//  BarHoppr
//
//  Created by csc313 on 1/24/16.
//  Copyright © 2016 CD Studios. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Parse

class MainVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{

    
    @IBOutlet weak var theMap: MKMapView!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        locationManager.requestAlwaysAuthorization()
        theMap.showsUserLocation = true
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.startUpdatingLocation()
        
    
        let query = PFQuery(className: "Bars")
        query.findObjectsInBackgroundWithBlock{ (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                let objects = objects
                for object in objects!
                {
                    var barLocation = object.valueForKey("barLocation") as! PFGeoPoint
                    print(barLocation)
                    
                    var pinLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(barLocation.latitude, barLocation.longitude)
                    var objectAnnotation = MKPointAnnotation()
                    objectAnnotation.coordinate = pinLocation
                    objectAnnotation.title = object.valueForKey("barName") as! String
                    self.theMap.addAnnotation(objectAnnotation)
                }
            }
        }
        
    }

    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        
        let currentLocation : CLLocation = locations[0]
        
        let long = currentLocation.coordinate.longitude
        let lat = currentLocation.coordinate.latitude
        let location : CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, long)
        
        let latDelta : CLLocationDegrees = 0.03
        let longDelta : CLLocationDegrees = 0.03
        let span : MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        
        let region : MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        theMap.setRegion(region, animated: true)

        userProfile.location = PFGeoPoint(latitude: lat, longitude: long)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func checkIn(sender: AnyObject) {
        print("MY LOCATION: \(userProfile.location)")
        print("MY ID: \(userProfile.userID)")

        
        var queryBars = PFQuery(className: "Bars")
            queryBars.whereKey("location", nearGeoPoint: userProfile.location, withinMiles: 1.0)
            queryBars.limit = 10
            do{
                var bars = try queryBars.findObjects()
                print("Closest Bar \(bars)")
            } catch {
                return
            }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
