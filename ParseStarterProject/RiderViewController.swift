//
//  RiderViewController.swift
//  ParseStarterProject
//
//  Created by Brad Gray on 8/29/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Parse

class RiderViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate  {
    
    var locationManager: CLLocationManager!
    
    var latitude: CLLocationDegrees = 0
    var longitude: CLLocationDegrees = 0
    
    var riderRequestActive = false
    
    
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var callUber: UIButton!
    
    @IBAction func callUberAction(sender: UIButton) {
        
        if riderRequestActive == false {
            
        
        var riderRequest = PFObject(className:"riderRequest")
        riderRequest["username"] = PFUser.currentUser()?.username
        riderRequest["location"] = PFGeoPoint(latitude: latitude, longitude: longitude)
       
        riderRequest.saveInBackgroundWithBlock {
            (succeded, error) -> Void in
            if (succeded) {
                self.callUber.setTitle("Cancel Uber", forState: UIControlState.Normal)
                
                
                
                
                
                
            } else {
                var alert = UIAlertController(title: "Could Not Call Uber", message: "Try Again", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)

            }
        }
            
            riderRequestActive = true
        
        } else {
            
            self.callUber.setTitle("Call an Uber", forState: UIControlState.Normal)

            riderRequestActive = false
            
            var query = PFQuery(className:"riderRequest")
            query.whereKey("username", equalTo: (PFUser.currentUser()!.username)!)
            query.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    // The find succeeded.
                    
                    
                    if let objects = objects as? [PFObject] {
                        for object in objects {
                            
                            
                            
                             object.deleteInBackground()
                        }
                    }
                } else {
                    print(error)
                    
                }
            }

        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
                  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
           }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        var location: CLLocationCoordinate2D = manager.location!.coordinate
        
        self.longitude = location.longitude
        self.latitude = location.latitude

        
        
        let center = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        
        self.map.setRegion(region, animated: true)
        
        self.map.removeAnnotations(map.annotations)
        
        
        
        
        var pinLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.latitude, location.longitude)
        var objectAnnotation = MKPointAnnotation()
        objectAnnotation.coordinate = pinLocation
        objectAnnotation.title = "your Location"
        self.map.addAnnotation(objectAnnotation)
        

    }
    
    
    
    
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "logOutRider" {
            PFUser.logOut()
            var currentUser = PFUser.currentUser()
        }
    }
    }
