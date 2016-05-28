//
//  InputViewController.swift
//  CalendarMoney
//
//  Created by 中安拓也 on 2016/05/28.
//  Copyright © 2016年 l08084. All rights reserved.
//

import UIKit

class InputViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var inputTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = String(indexPath.row)
        return cell
    }
}
