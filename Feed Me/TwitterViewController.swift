//
//  TwitterViewController.swift
//  DestHack
//
//  Created by Bhargavi Kulkarni on 06/02/16.
//  Copyright (c) 2016 Bhargavi Kulkarni. All rights reserved.
//

import UIKit
import Accounts
import Social

class TwitterViewController: UIViewController,UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var tweetTableView: UITableView!
    @IBOutlet weak var txtInputData: UITextField!
    
    var dataSource = NSMutableArray()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetTableView.layer.borderWidth = 1.0
        tweetTableView.layer.borderColor = UIColor.grayColor().CGColor
        tweetTableView.layer.cornerRadius = 5.0
        if txtInputData.text == ""
        {
            self.getTimeLine("Venturesity")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tweetTableView.dequeueReusableCellWithIdentifier("Cell") as! TwitterTableViewCell
        let row = indexPath.row
        let tweet: AnyObject = self.dataSource[row]
        cell.lblData.text = tweet as? String
        if NSString(string: cell.lblData.text!).containsString("good") || NSString(string: cell.lblData.text!).containsString("excellent") || NSString(string: cell.lblData.text!).containsString("beautiful") ||
            NSString(string: cell.lblData.text!).containsString("well org")
        {
            cell.imgCheck.layer.cornerRadius = 15.0
            cell.imgCheck.backgroundColor = UIColor.greenColor()
        }
        else if NSString(string: cell.lblData.text!).containsString("poor") || NSString(string: cell.lblData.text!).containsString("bad") || NSString(string: cell.lblData.text!).containsString("not") ||
            NSString(string: cell.lblData.text!).containsString("didn't")
        {
            cell.imgCheck.layer.cornerRadius = 15.0
            cell.imgCheck.backgroundColor = UIColor.redColor()
        }
        else
        {
            cell.imgCheck.layer.cornerRadius = 15.0
            cell.imgCheck.backgroundColor = UIColor.orangeColor()
        }
        
        
        return cell
    }
    
    
    func getTimeLine(textEntered : String) {
        
        let account = ACAccountStore()
        let accountType = account.accountTypeWithAccountTypeIdentifier(
            ACAccountTypeIdentifierTwitter)
        
        account.requestAccessToAccountsWithType(accountType, options: nil,
            completion: {(success: Bool, error: NSError!) -> Void in
                
                if success {
                    let arrayOfAccounts =
                    account.accountsWithAccountType(accountType)
                    
                    if arrayOfAccounts.count > 0 {
                        let twitterAccount = arrayOfAccounts.last as! ACAccount
                        
                        let requestURL = NSURL(string:
                            //"https://api.twitter.com/1.1/search/tweets.json?q=%40twitterapi")
                            "https://api.twitter.com/1.1/search/tweets.json")
                        //"https://api.twitter.com/1.1/statuses/user_timeline.json")
                        //"https://api.twitter.com/1.1/followers/ids.json")
                        
                        let parameters = ["q" : "@\(textEntered)",
                            //"screen_name" : "@AMITH_SHAJU",
                            //"include_rts" : "0",
                            //"trim_user" : "1",
                            //"cursor" : "3",
                            //"since_id" : "2401261998",
                            //"max_id" : "25012619984",
                            "result_type" : "mixed",
                            "count" : "50"]
                        
                        let postRequest = SLRequest(forServiceType:
                            SLServiceTypeTwitter,
                            requestMethod: SLRequestMethod.GET,
                            URL: requestURL,
                            parameters: parameters)
                        
                        postRequest.account = twitterAccount
                        
                        postRequest.performRequestWithHandler(
                            {(responseData: NSData!,
                                urlResponse: NSHTTPURLResponse!,
                                error: NSError!) -> Void in
                                var err: NSError?
                                //                                self.dataSource = NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.MutableLeaves, error: &err) as! [AnyObject]
                                var json = NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.MutableLeaves, error: &err) as! NSDictionary!
                                var pdts = json.objectForKey("statuses") as! [NSDictionary!]!
                                
                                self.tweetTableView.reloadData()
                              if pdts != nil
                              {
                                for i in 0..<pdts.count
                                {
                                  var pdt = pdts[i] as NSDictionary!
                                  let text = pdt.objectForKey("text") as! String!
                                  self.dataSource[i] = text
                                }
                                
                                println(self.dataSource.count)
                                println("\(self.dataSource)")
                                if self.dataSource.count != 0 {
                                  dispatch_async(dispatch_get_main_queue()) {
                                    self.tweetTableView.reloadData()
                                  }
                                }
                              }
                        })
                    }
                } else {
                    println("Failed to access account")
                }
        })
    }
    @IBAction func btnSearchTapped(sender: AnyObject) {
        getTimeLine(txtInputData.text)
        txtInputData.endEditing(true)
    }
    
}

