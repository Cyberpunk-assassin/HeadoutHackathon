//
//  ContactViewController.swift
//  ssss
//
//  Created by Bhargavi Kulkarni on 06/02/16.
//  Copyright (c) 2016 Bhargavi Kulkarni. All rights reserved.
//


import UIKit

class ContactViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnCallTapped(sender: AnyObject) {
        callNumber("8123428945")
    }
    
    // Call
    private func callNumber(phoneNumber:String) {
        if let phoneCallURL:NSURL = NSURL(string: "tel://\(phoneNumber)") {
            let application:UIApplication = UIApplication.sharedApplication()
            if (application.canOpenURL(phoneCallURL)) {
                application.openURL(phoneCallURL);
            }
            else
            {
                let alert = UIAlertView()
                alert.title = "Sorry!"
                alert.message = "Phone number is not available for this business"
                alert.addButtonWithTitle("Ok")
                alert.show()
            }
        }
    }
    
    // face time
    private func facetime(phoneNumber:String) {
        if let facetimeURL:NSURL = NSURL(string: "facetime://\(phoneNumber)") {
            let application:UIApplication = UIApplication.sharedApplication()
            if (application.canOpenURL(facetimeURL)) {
                application.openURL(facetimeURL);
            }
            else
            {
                let alert = UIAlertView()
                alert.title = "Sorry!"
                alert.message = "Phone face time is not available for this business"
                alert.addButtonWithTitle("Ok")
                alert.show()
            }

        }
    }

}

