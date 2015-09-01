//
//  RequestsViewController.swift
//  ParseStarterProject
//
//  Created by Brad Gray on 8/31/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import MapKit
import Parse

class RequestsViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var map: MKMapView!
    
    
    @IBAction func pickUpRider(sender: UIButton) {
        
        var query = PFQuery(className:"riderRequest")
        query.whereKey("username", equalTo: requestUsername)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                
                
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        
                       object["driverResponded"] = PFUser.currentUser()!.username!
                        object.save()
                        
                        let requestCLLocation = CLLocation(latitude: self.requestLocation.latitude, longitude: self.requestLocation.longitude)
                        
                        CLGeocoder().reverseGeocodeLocation(requestCLLocation, completionHandler: { (placemarks, error) -> Void in
                            if error != nil {
                                print(error)
                            }
                            if placemarks!.count > 0 {
                                
                                let pm = placemarks![0] as! CLPlacemark

                                let mkPm = MKPlacemark(placemark: pm)
                                
                                var mapItem = MKMapItem(placemark: mkPm)
                                
                                mapItem.name = self.requestUsername
                                
                                
                                var launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                                
                                mapItem.openInMapsWithLaunchOptions(launchOptions)
                                
                            } else {
                                print("problems with the data received from geocoder")
                            }
                            
                        })
                        
                        
                       
                        
                        
                        
                        
                        
                    }
                }
            } else {
                print(error)
                
            }
        }
        
        
    }
    
    var requestLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(0, 0)
    var requestUsername: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(requestUsername)
        print(requestLocation)
        
        
        
        
        let region = MKCoordinateRegion(center: requestLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        
        self.map.setRegion(region, animated: true)
        
        
        
        var objectAnnotation = MKPointAnnotation()
        objectAnnotation.coordinate = requestLocation
        objectAnnotation.title = requestUsername
        self.map.addAnnotation(objectAnnotation)
        
        
        
        
        

        // Do any additional setup after loading the view.
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
