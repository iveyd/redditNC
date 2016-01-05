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
    
    
    
    
    @IBOutlet var postLabels: [UILabel]!
    
    @IBOutlet var postThumbnails: [UIImageView]!
    
    struct readyPost {
        var title:String
        var thumbnail:String
        var subredditName:String
        
    }
    
    
    
    @IBOutlet weak var test: UISegmentedControl!
    
    var finalPostArray:[readyPost] = []
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
            subredditList.append(temp)
        }
        
        
       
        super.viewDidLoad()
         updateScreen()
        self.preferredContentSize = CGSizeMake(0, 700);
        // Do any additional setup after loading the view from its nib.
    }
    
    
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
        
        let test = fetchPostContent()
        print(test)
        print("Hello")
        print(self.finalPostArray.count)
        
        updateScreen()
        self.preferredContentSize = CGSizeMake(0, 700);

        completionHandler(NCUpdateResult.NewData)
    }
    
    func updateScreen(){
        if self.finalPostArray.count >= 5{
            for i in 0..<self.postLabels.count{
                self.postLabels[i].text = self.finalPostArray[i].title
                if  self.finalPostArray[i].thumbnail != "self" && self.finalPostArray[i].thumbnail != ""{
                    
                    self.postThumbnails[i].image = UIImage(data: NSData(contentsOfURL: NSURL(string: self.finalPostArray[i].thumbnail)!)!)
                    self.postThumbnails[i].contentMode = .ScaleAspectFit
                }
            }
        }
    }
}
