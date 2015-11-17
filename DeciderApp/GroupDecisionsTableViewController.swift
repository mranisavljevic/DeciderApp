//
//  GroupDecisionsTableViewController.swift
//  DeciderApp
//
//  Created by Matthew Weintrub on 11/17/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

import UIKit

class GroupDecisionsTableViewController: UITableViewController {
    
    var myPhone = "2064272503" //This needs to be replaced with the user's phone number
    
    var events = [Event]() {
        didSet {
            print(events.count)
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMyEvents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func fetchMyEvents() {
        ParseService.loadMyEvents(self.myPhone) { (success, events) -> () in
            if success {
                if let events = events {
                    self.events = events
                }
            } else {
                print("Error - did not retrieve events")
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.events.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(GroupDecisionsTableViewCell.identifier(), forIndexPath: indexPath) as! GroupDecisionsTableViewCell
        cell.event = self.events[indexPath.row]
        return cell
    }

}
