//
//  DriverViewController.swift
//  ParseStarterProject
//
//  Created by Brad Gray on 8/30/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse
import MapKit

class DriverViewController: UITableViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    
    var latitude: CLLocationDegrees = 0
    var longitude: CLLocationDegrees = 0

    var usernames = [String]()
    var locations = [CLLocationCoordinate2D]()
    
    var distances = [CLLocationDistance]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

       
        
      
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        var location: CLLocationCoordinate2D = manager.location!.coordinate
        
        self.longitude = location.longitude
        self.latitude = location.latitude
        
        var query = PFQuery(className:"riderRequest")
        
        query.whereKey("location", nearGeoPoint: PFGeoPoint(latitude: location.latitude, longitude: location.longitude))
        query.limit = 10
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                
                
                if let objects = objects as? [PFObject] {
                    
                    self.locations.removeAll()
                    self.usernames.removeAll()
                    
                    for object in objects {
                        
                        if object ["driverResponded"] == nil {
                        
                        if let username = object["username"] as? String {
                            
                        
                            self.usernames.append(username)
                        }
                        
                        
                        
                        if let returnedLocation = object["location"] as? PFGeoPoint {
                            
                            let requestLocation = (CLLocationCoordinate2DMake(returnedLocation.latitude, returnedLocation.longitude))
                            
                            self.locations.append(requestLocation)
                            
                            let requestCLLocation = CLLocation(latitude: requestLocation.latitude, longitude: requestLocation.longitude)
                            
                            let driverCLLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
                            let distance = driverCLLocation.distanceFromLocation(requestCLLocation)
                            
                            self.distances.append(distance / 1000)
                            
                            
                            }
                    
                        }
                        
                    }
                    self.tableView.reloadData()

                }
                
                
            } else {
                print(error)
                
            }
        }
        
        
        
        
        
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return usernames.count
        
        
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        var distanceDouble = Double(distances[indexPath.row])
        
        var roundedDistance = Double(round(distanceDouble * 10) / 10)
        
        
        
        cell.textLabel?.text = usernames[indexPath.row] +  " - " + String(roundedDistance) + " km away"
        
        

        return cell
    }
    
    
    
        override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            if segue.identifier == "logoutDriver" {
                PFUser.logOut()
                var currentUser = PFUser.currentUser()
                
            
            } else if segue.identifier == "showViewRequests" {
            
            if let destination = segue.destinationViewController as? RequestsViewController {
                
                destination.requestLocation = locations[(tableView.indexPathForSelectedRow?.row)!]
                 destination.requestUsername = usernames[(tableView.indexPathForSelectedRow?.row)!]
            
    }
            }
            
    }


   
}
