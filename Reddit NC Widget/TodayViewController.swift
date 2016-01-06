//
//  TodayViewController.swift
//  Reddit NC Widget
//
//  Created by John Behnke on 7/28/15.
//  Copyright (c) 2015 John Behnke. All rights reserved.
//

import UIKit
import NotificationCenter





class TodayViewController:  UIViewController ,NCWidgetProviding {
    
    
    
    @IBOutlet weak var pageSwitch: UISegmentedControl!
    
    @IBOutlet var updatedLabel: UILabel!
    @IBOutlet var postComments: [UILabel]!
    
    @IBAction func switchReddit(sender: UISegmentedControl) {
        updateScreen()
        NCUpdateResult.NewData
        
    }
    
    @IBOutlet var postUpVotes: [UILabel]!
    @IBOutlet var postLabels: [UILabel]!
    
    @IBOutlet var postLabelsNonImage: [UILabel]!
    
    @IBOutlet var postThumbnails: [UIImageView]!
    
    struct readyPost {
        var title:String
        var thumbnail:String
        var ups: Int
        var num_comments: Int
        
        
        
    }
    
    struct postPage {
        var subredditName:String
        var posts:[readyPost]
    }
    
    
    
    var lastUpdate:Double?
    var finalPostArray:[postPage] = []
    var subredditList:[String] = []
    let defaults:NSUserDefaults = NSUserDefaults(suiteName: "group.me.johnbehnke.RedditNC")!
    
    
    func widgetMarginInsetsForProposedMarginInsets
        (defaultMarginInsets: UIEdgeInsets) -> (UIEdgeInsets) {
            
            return UIEdgeInsetsZero
    }
    
    
    override func viewDidLoad() {
        
        let recoveredSubReddits = (defaults.objectForKey("subredditList")) as? String
        
        let tempArray = recoveredSubReddits?.componentsSeparatedByString("|")
        let tempArray2 = tempArray?.dropLast()
        for temp in tempArray2!{
            self.subredditList.append(temp)
        }
        self.pageSwitch.removeAllSegments()
        for i in 0..<self.subredditList.count{
            self.pageSwitch.insertSegmentWithTitle("\(self.subredditList[i])", atIndex: i, animated: true)
        }
        
        
        self.pageSwitch.selectedSegmentIndex = 0
        self.lastUpdate = defaults.objectForKey("timeSinceUpdate") as? Double
        super.viewDidLoad()
        updateScreen()
        
        // Do any additional setup after loading the view from its nib.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func fetchPostContent() {
        
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
                        var tempPushArray:[readyPost] = []
                        for (var i = 0; i < (5 + stickySkip); i++){
                            let redditJSON: Dictionary<String,AnyObject> = results[i] as! Dictionary
                            let isSticky:Bool = redditJSON["data"]!["stickied"] as! Bool
                            if isSticky{
                                continue
                            }
                            else{
                                let tempPostTitle = redditJSON["data"]!["title"] as? String
                                let tempPostImageURL = redditJSON["data"]!["thumbnail"] as? String
                                let tempPostUps = redditJSON["data"]!["ups"] as? Int
                                let tempPostComments = redditJSON["data"]!["num_comments"] as? Int
                                let tempStruct = readyPost(title: tempPostTitle!, thumbnail: tempPostImageURL!, ups: tempPostUps!, num_comments: tempPostComments!)
                                
                                tempPushArray.append(tempStruct)
                                
                            }
                            
                        }
                        self.finalPostArray.append(postPage(subredditName: post, posts: tempPushArray))
                        
                        
                        
                        
                    }
                    
                } catch {
                    print("error serializing JSON: \(error)")
                }
                
                
                
            }
        }
        
        
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        //let updatedNow  = NSTimeIntervalSince1970
        ///self.lastUpdate = (defaults.objectForKey("timeSinceUpdate")) as? Double
        //if updatedNow - self.lastUpdate! != 0{
            //self.defaults.setObject(updatedNow, forKey: "timeSinceUpdate")
            //self.updatedLabel.text = "\(updatedNow - self.lastUpdate!)"
            //updateScreen()
            
            //completionHandler(NCUpdateResult.NewData)
        //}
        //else{
            //self.defaults.setObject(updatedNow, forKey: "timeSinceUpdate")

            fetchPostContent()
            
            
            print(self.finalPostArray.count)
            
            updateScreen()
            
            
            completionHandler(NCUpdateResult.NewData)
       //}
    }
    
    func updateScreen(){
        if self.finalPostArray.count >= 1{
            
            
            //self.updatedLabel.text = "\((updatedNow - self.lastUpdate!))"
            var pageNumber = self.pageSwitch.selectedSegmentIndex
            if pageNumber == -1{
                pageNumber = 0
            }
            
            
            for i in 0..<5{
                
                self.postUpVotes[i].text = "\(self.finalPostArray[pageNumber].posts[i].ups)"
                self.postComments[i].text = "\(self.finalPostArray[pageNumber].posts[i].num_comments)"
                
                if  self.finalPostArray[pageNumber].posts[i].thumbnail != "self" && self.finalPostArray[pageNumber].posts[i].thumbnail != "" &&   self.finalPostArray[pageNumber].posts[i].thumbnail != "nsfw" {
                    
                    self.postThumbnails[i].image = UIImage(data: NSData(contentsOfURL: NSURL(string: self.finalPostArray[pageNumber].posts[i].thumbnail)!)!)
                    self.postThumbnails[i].contentMode = .ScaleAspectFit
                    self.postLabels[i].hidden = false
                    self.postLabelsNonImage[i].hidden = true
                    self.postLabels[i].text = self.finalPostArray[pageNumber].posts[i].title
                }
                else{
                    self.postThumbnails[i].image = nil
                    self.postLabels[i].hidden = true
                    self.postLabelsNonImage[i].hidden = false
                    self.postLabelsNonImage[i].text = self.finalPostArray[pageNumber].posts[i].title
                    
                    
                }
            }
        }
    }
}
