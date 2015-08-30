//
//  ViewController.swift
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController, UITextFieldDelegate {
    
    func displayAlert(title: String, message: String) {
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)

    }

    var signUpState = true
    
    
    @IBOutlet weak var username: UITextField!
    

    @IBOutlet weak var password: UITextField!


    @IBOutlet weak var `switch`: UISwitch!
    
    @IBOutlet weak var riderLabel: UILabel!
    
    @IBOutlet weak var driverLabel: UILabel!
    
    
    @IBAction func signUp(sender: UIButton) {
        
        
        if username.text == "" || password.text == "" {
           
            displayAlert("Missing Text Field(s)", message: "username, password or both are required")
        
        
        } else {
            
            if signUpState == true {
            
                var user = PFUser()
                user.username = username.text
                user.password = password.text

                
            user["isDriver"] = `switch`.on
            
            
            user.signUpInBackgroundWithBlock {
                (succeded, error) -> Void in
                if let error = error {
                    if let errorString = error.userInfo["error"] as? String {
                        
                        self.displayAlert("Sign Up Failed", message: errorString)

                    }
                
                } else {
                    self.performSegueWithIdentifier("loginRider", sender: self)
                }
                }
                    
                    
            } else {
                PFUser.logInWithUsernameInBackground(username.text!, password: password.text!) {
                    (user: PFUser?, error: NSError?) -> Void in
                    if user != nil {
                        self.performSegueWithIdentifier("loginRider", sender: self)
                    } else {
                        if let errorString = error?.userInfo["error"] as? String {
                            
                            self.displayAlert("Login Failed", message: errorString)
                            
                        }
                    }
                }
                
                
            }
            }
        }
    
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBAction func signUpToggled(sender: UIButton) {
        
        if signUpState == true {
            signUpButton.setTitle("Log In", forState: UIControlState.Normal)
            
            toggleSignUpButton.setTitle("Switch to Signup", forState: UIControlState.Normal)
            signUpState = false
            
            riderLabel.alpha = 0
            driverLabel.alpha = 0
            `switch`.alpha = 0
            
        } else {
            
            signUpButton.setTitle("Sign Up", forState: UIControlState.Normal)
            
            toggleSignUpButton.setTitle("Switch to Login", forState: UIControlState.Normal)
            signUpState = true
            
            riderLabel.alpha = 1
            driverLabel.alpha = 1
            `switch`.alpha = 1

        }
        
        
    }
        
    @IBOutlet weak var toggleSignUpButton: UIButton!
          
        
    
    
    override func viewDidLoad() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        self.username.delegate = self
        self.password.delegate = self
    }
    
    



      override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //Calls this function when the tap is recognized.
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func viewDidAppear(animated: Bool) {
        if PFUser.currentUser()?.username != nil {
            performSegueWithIdentifier("loginRider", sender: self)
        }
    }

}

