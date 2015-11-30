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
    
    var subredditList:[String] = []
    let defaults:NSUserDefaults = NSUserDefaults(suiteName: "group.me.johnbehnke.RedditNC")!
    
    func resetContentSize(){
        self.preferredContentSize = tableView.contentSize
    }
    
    
    override func viewDidLoad() {
        var x = (defaults.objectForKey("subredditList")) as? String

        var v = x?.componentsSeparatedByString("|")
        var c = v?.dropLast()
        for a in c!{
            subredditList.append(a)
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
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        self.tableView.reloadData()
        
        completionHandler(NCUpdateResult.NewData)
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.subredditList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("test", forIndexPath: indexPath)
        
        cell.textLabel?.text = self.subredditList[indexPath.row]
        
        return cell
    }
    
}
