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
    
    var driverIsOnTheWay = false
    
    var riderRequestActive = false
    
    var locationManager: CLLocationManager!
    
    var latitude: CLLocationDegrees = 0
    var longitude: CLLocationDegrees = 0
    
    
    
    
    @IBOutlet weak var map: MKMapView!
    
    @IBOutlet weak var callUber: UIButton!
    
    @IBAction func callUberAction(sender: UIButton) {
        
        if riderRequestActive == false {
            
        
        var riderRequest = PFObject(className:"riderRequest")
        riderRequest["username"] = PFUser.currentUser()?.username
        riderRequest["location"] = PFGeoPoint(latitude: latitude, longitude: longitude)
       
        riderRequest.saveInBackgroundWithBlock {
            (success, error) -> Void in
            if (success) {
                
                self.callUber.setTitle("cancel Uber", forState: UIControlState.Normal)
                
                
                
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
            
            query.whereKey("username", equalTo: PFUser.currentUser()!.username!)
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
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
                  }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
           }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        var location: CLLocationCoordinate2D = manager.location!.coordinate
        
        self.longitude = location.longitude
        self.latitude = location.latitude
        
       var query = PFQuery(className:"riderRequest")
        
        if PFUser.currentUser()!.username != nil {
        
       // var username1 = PFUser.currentUser()!.username!
        
        //if username1 != nil {
         query.whereKey("username", equalTo: PFUser.currentUser()!.username!)
       
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                
                
                if let objects = objects as? [PFObject] {
                    
                    
                    for object in objects {
                        
                        print("riderRequest Found")
                        
                        if let driverUserName = object["driverResponded"] {
                        
                            
                            
                            
                            
                            
                            var query = PFQuery(className:"driverLocation")
                            
                            query.whereKey("username", equalTo: driverUserName)
                            
                            
                            query.findObjectsInBackgroundWithBlock {
                                (objects: [AnyObject]?, error: NSError?) -> Void in
                                
                                if error == nil {
                                    // The find succeeded.
                                    print("succeeded")
                                    
                                    if let objects = objects as? [PFObject] {
                                        
                                        
                                        for object in objects {
                                            
                                            print(object)
                                            
                                             if let driverLocation = object["driverLocation"] as? PFGeoPoint {
                                                
                                                print(driverLocation)
                                                
                                                
                                                let driverCLLocation = CLLocation(latitude: driverLocation.latitude, longitude: driverLocation.longitude)
                                                let userCLLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
                                                
                                              
                                                let distanceMeters = userCLLocation.distanceFromLocation(driverCLLocation)
                                                let distanceKM = distanceMeters / 1000
                                                
                                                print(distanceKM)
                                                let roundedTwoDigitDistance = Double(round(distanceKM * 10) / 10)
                                                
                                                print(roundedTwoDigitDistance)
                            
                                                self.callUber.setTitle("Driver is \(roundedTwoDigitDistance) km away", forState: UIControlState.Normal)
                                                
                                                self.driverIsOnTheWay = true
                                                
                                                
                                                let center = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
                                                
                                                let latDelta = abs(driverLocation.latitude - location.latitude) * 2 + 0.01
                                                let longDelta = abs(driverLocation.longitude - location.longitude) * 2 + 0.01

                                                
                                                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta:latDelta, longitudeDelta: longDelta))
                                                
                                                
                                                self.map.setRegion(region, animated: true)
                                                
                                                self.map.removeAnnotations(self.map.annotations)
                                                
                                                
                                                
                                                
                                                var pinLocation : CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.latitude, location.longitude)
                                                var objectAnnotation = MKPointAnnotation()
                                                objectAnnotation.coordinate = pinLocation
                                                objectAnnotation.title = "your Location"
                                                self.map.addAnnotation(objectAnnotation)
                                                
                                                
                                                
                                                 pinLocation = CLLocationCoordinate2DMake(driverLocation.latitude, driverLocation.longitude)
                                                objectAnnotation = MKPointAnnotation()
                                                objectAnnotation.coordinate = pinLocation
                                                objectAnnotation.title = "Driver Location"
                                                self.map.addAnnotation(objectAnnotation)


                                            }
                            
                                        }
                                    }
                                }
                            }
                            
                            
                            
                            
                            
                        }
                    }
                }
            }
        }
    
        
        }
        
        
        

        if (driverIsOnTheWay == false) {
        
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

    }
    
    
    
    
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "logOutRider" {
            PFUser.logOut()
                   }
    }
    }
