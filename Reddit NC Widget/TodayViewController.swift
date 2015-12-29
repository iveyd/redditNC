//
//  TodayViewController.swift
//  Reddit NC Widget
//
//  Created by John Behnke on 7/28/15.
//  Copyright (c) 2015 John Behnke. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UITableViewController, NCWidgetProviding {
    
    
    
    struct readyPost {
        var title:String
        var thumbnail:String
        var subredditName:String
        
    }
    
    
    
    
    var finalPostArray:[readyPost] = []
    var subredditList:[String] = []
    let defaults:NSUserDefaults = NSUserDefaults(suiteName: "group.me.johnbehnke.RedditNC")!
    
    func resetContentSize(){
        self.preferredContentSize = tableView.contentSize
    }
    
    
    override func viewDidLoad() {
        let recoveredSubReddits = (defaults.objectForKey("subredditList")) as? String
        
        let tempArray = recoveredSubReddits?.componentsSeparatedByString("|")
        let tempArray2 = tempArray?.dropLast()
        for temp in tempArray2!{
            subredditList.append(temp)
        }
        
        self.tableView.reloadData()
        
        super.viewDidLoad()
        resetContentSize()
        // Do any additional setup after loading the view from its nib.
    }
    @IBOutlet weak var test: UILabel!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func fetchPostContent() -> Bool{
        
        for post in self.subredditList{
            
            let endpoint = NSURL(string: "https://www.reddit.com/r/\(post)/.json")
            let data = NSData(contentsOfURL: endpoint!)
            
            if data != nil{
                
                
                
                
                
                
                
                
                
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers)
                    
                    
                    if let results:[AnyObject] = json["data"]!!["children"] as? Array {
                        
                        var stickySkip: Int = 0
                        
                        for possibleSticky in 0..<5{
                            let redditJSON: Dictionary<String,AnyObject> = results[possibleSticky] as! Dictionary
                            let isSticky:Bool = redditJSON["data"]!["stickied"] as! Bool
                            if isSticky{
                                stickySkip++
                            }
                        }
                        
                        for (var i = 0; i < (5 + stickySkip); i++){
                            let redditJSON: Dictionary<String,AnyObject> = results[i] as! Dictionary
                            let isSticky:Bool = redditJSON["data"]!["stickied"] as! Bool
                            if isSticky{
                                continue
                            }
                            else{
                                let tempPostTitle = redditJSON["data"]!["title"] as? String
                                let tempPostImageURL = redditJSON["data"]!["thumbnail"] as? String
                                
                                let tempStruct = readyPost(title: tempPostTitle!, thumbnail: tempPostImageURL!, subredditName: post)
                                
                                self.finalPostArray.append(tempStruct)
                                
                            }
                            
                            
                            
                        }
                        return true
                        
                        
                        
                    }
                } catch {
                    print("error serializing JSON: \(error)")
                    return false
                }
                
                
                
                
                
                
                
                
                
            }
        }
        return false
    }
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        var test = fetchPostContent()
        print("Hello")
        print(self.finalPostArray.count)
        self.tableView.reloadData()
        
        completionHandler(NCUpdateResult.NewData)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.finalPostArray.count > 0{
            return self.finalPostArray.count
        }
        else{
            return 5
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if self.finalPostArray.count > 0{
            
            let cell = tableView.dequeueReusableCellWithIdentifier("test", forIndexPath: indexPath)
            
            cell.textLabel?.text = self.finalPostArray[indexPath.row].title
            
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCellWithIdentifier("test", forIndexPath: indexPath)
            
            cell.textLabel?.text = "Nothing :("
            return cell
            
            
        }
    }
    
}
