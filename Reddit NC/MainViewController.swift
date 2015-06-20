//
//  MainViewController.swift
//  Reddit NC
//
//  Created by John Behnke on 6/19/15.
//  Copyright (c) 2015 John Behnke. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    //MARK: Global Variables
    
    //RGB Values for certain UI Colors
    let disabledCellBackgroundColor:UIColor = UIColor(red: 0.925, green: 0.922, blue: 0.953, alpha: 1)
    let disabledUserTextColor:UIColor       = UIColor(red: 0.745, green: 0.741, blue: 0.769, alpha: 1)
    let customBlueColor:UIColor             = UIColor(red: 0.255, green: 0.745, blue: 1, alpha: 1)
    
    //Used for App Groups and to save to NSUserDefaults
    let defaults:NSUserDefaults = NSUserDefaults(suiteName: "group.me.johnbehnke.RedditNC")!
    
    var subredditArray: [String] = []
    
    
    
    //MARK: IBOutletCollections
    
    @IBOutlet var subredditTableViewCells: [UITableViewCell]!
    
    @IBOutlet var subredditInputFields: [UITextField]!
    
    @IBOutlet var subredditUISwitches: [UISwitch]!
    
    //MARK: IBActions
    @IBAction func switchOne(sender: UISwitch) {
        
        if sender.on{
            
            self.subredditTableViewCells[0].backgroundColor = UIColor.whiteColor()
            self.subredditInputFields[0].placeholder = "Subreddit"
            self.subredditInputFields[0].userInteractionEnabled = true
            self.subredditInputFields[0].textColor = UIColor.blackColor()
            
        }
        else{
            self.subredditTableViewCells[0].backgroundColor = disabledCellBackgroundColor
            self.subredditInputFields[0].placeholder = "Disabled"
            self.subredditInputFields[0].userInteractionEnabled = false
            self.subredditInputFields[0].textColor = disabledUserTextColor
        }
        
    }
    
    @IBAction func switchTwo(sender: UISwitch) {
        if sender.on{
            self.subredditTableViewCells[1].backgroundColor = UIColor.whiteColor()
            self.subredditInputFields[1].placeholder = "Subreddit"
            self.subredditInputFields[1].userInteractionEnabled = true
            self.subredditInputFields[1].textColor = UIColor.blackColor()
            
        }
        else{
            self.subredditTableViewCells[1].backgroundColor = disabledCellBackgroundColor
            self.subredditInputFields[1].placeholder = "Disabled"
            self.subredditInputFields[1].userInteractionEnabled = false
            self.subredditInputFields[1].textColor = disabledUserTextColor
        }
        
    }
    
    @IBAction func switchThree(sender: UISwitch) {
        if sender.on{
            
            self.subredditTableViewCells[2].backgroundColor = UIColor.whiteColor()
            self.subredditInputFields[2].placeholder = "Subreddit"
            self.subredditInputFields[2].userInteractionEnabled = true
            self.subredditInputFields[2].textColor = UIColor.blackColor()
            
        }
        else{
            self.subredditTableViewCells[2].backgroundColor = disabledCellBackgroundColor
            self.subredditInputFields[2].placeholder = "Disabled"
            self.subredditInputFields[2].userInteractionEnabled = false
            self.subredditInputFields[2].textColor = disabledUserTextColor
        }
        
    }
    
    @IBAction func switchFour(sender: UISwitch) {
        if sender.on{
            self.subredditTableViewCells[3].backgroundColor = UIColor.whiteColor()
            self.subredditInputFields[3].placeholder = "Subreddit"
            self.subredditInputFields[3].userInteractionEnabled = true
            self.subredditInputFields[3].textColor = UIColor.blackColor()
            
        }
        else{
            self.subredditTableViewCells[3].backgroundColor = disabledCellBackgroundColor
            self.subredditInputFields[3].placeholder = "Disabled"
            self.subredditInputFields[3].userInteractionEnabled = false
            self.subredditInputFields[3].textColor = disabledUserTextColor
        }
        
    }
    
    @IBAction func switchFive(sender: UISwitch) {
        if sender.on{
            self.subredditTableViewCells[4].backgroundColor = UIColor.whiteColor()
            self.subredditInputFields[4].placeholder = "Subreddit"
            self.subredditInputFields[4].userInteractionEnabled = true
            self.subredditInputFields[4].textColor = UIColor.blackColor()
            
            
        }
        else{
            self.subredditTableViewCells[4].backgroundColor = disabledCellBackgroundColor
            self.subredditInputFields[4].placeholder = "Disabled"
            self.subredditInputFields[4].userInteractionEnabled = false
            self.subredditInputFields[4].textColor = disabledUserTextColor
        }
        
    }
    
    
    @IBAction func savePressed(sender: UIBarButtonItem) {
        
        let numberOfSubreddits = self.subredditArray.count
        
        //Store how many subreddits the user selects. This is used to control the unpacking for-loop in the NC widget that unpacks the data.
        self.defaults.setObject(numberOfSubreddits, forKey: "numberOfSubreddits")
        
        self.subredditArray.removeAll(keepCapacity: false)
        
        for i in 0..<self.subredditInputFields.count{
            
            //Check to see if user actaully entered in all subreddits he/she turned on
            if self.subredditInputFields[i].text.isEmpty && self.subredditUISwitches[i].on{
                
                var alert:UIAlertController = UIAlertController(title: "Warning", message: "Invalid subreddit! You must enter a subreddit if the switch for that slot is on!", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                
                break
            }
            
            //Strip any spaces from the subreddit and convert it to a lowercase string
            let correctedText: String  = self.subredditInputFields[i].text.lowercaseString.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            //Pack the data into NSDefaults
            self.defaults.setObject(correctedText, forKey: "subreddit\(i)")
            
        }
        
        
    }
    
    //MARK: Default Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Helper Functions
    
    
    //TODO  I dont like this solution :/ Make something better
    
//    func testSubredditExistance(subredditName: String) ->Bool{
//        
//        
//        var url = NSURL(string: "http://www.reddit.com/r/\(subredditName)")!// Creating URL
//        var request:NSMutableURLRequest = NSMutableURLRequest(URL:url)
//        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) -> Void in
//            if let HTTPResponse = response as? NSHTTPURLResponse {
//                let statusCode = HTTPResponse.statusCode
//                println(statusCode)
//            }
//        }
//        return true
//    }
}
