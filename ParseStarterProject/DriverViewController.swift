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

    var usernames = [String]()
    var locations = [CLLocationCoordinate2D]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var query = PFQuery(className:"riderRequest")
       
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                
                
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        
                        if let username = object["username"] as? String {
                           self.usernames.append(username)
                        }
                        if let location = object["location"] as? PFGeoPoint {
                            self.locations.append(CLLocationCoordinate2DMake(location.latitude, location.longitude))
                        
                            
                        
                        }
                    }
                }
                self.tableView.reloadData()
                print(self.usernames)
                print(self.locations)
                
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

        cell.textLabel?.text = usernames[indexPath.row]
        

        return cell
    }
    
    
        override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
            if segue.identifier == "logoutDriver" {
                PFUser.logOut()
                var currentUser = PFUser.currentUser()
            }
        }


   
}
