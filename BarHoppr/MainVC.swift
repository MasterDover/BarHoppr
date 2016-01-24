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
        
    
        
        
    }

    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
        
        let currentLocation : CLLocation = locations[0] as! CLLocation
        
        let long = currentLocation.coordinate.longitude
        let lat = currentLocation.coordinate.latitude
        let location : CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, long)
        
        let latDelta : CLLocationDegrees = 0.03
        let longDelta : CLLocationDegrees = 0.03
        let span : MKCoordinateSpan = MKCoordinateSpanMake(latDelta, longDelta)
        
        
        let region : MKCoordinateRegion = MKCoordinateRegionMake(location, span)
        theMap.setRegion(region, animated: true)

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
