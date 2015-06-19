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
    
    var subredditArray: [String] = []

    
    //MARK: IBOutletCollections
    
    @IBOutlet var subredditTableViewCells: [UITableViewCell]!
    
    @IBOutlet var subredditInputFields: UITextField!
    
    @IBOutlet var subredditUISwitches: [UISwitch]!
    
    //MARK: IBActions
    
    
    //MARK: Default functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

