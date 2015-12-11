//
//  GroupDecisionsTableViewController.swift
//  DeciderApp
//
//  Created by Matthew Weintrub on 11/17/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

import UIKit

class GroupDecisionsTableViewController: UITableViewController {
    
    var events = [Event]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
        UINavigationBar.setNavBar((self.navigationController?.navigationBar)!)
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .ScaleAspectFit
        let image = UIImage(named: "logo")
        imageView.image = image
        navigationItem.titleView = imageView
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        fetchMyEvents()
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func fetchMyEvents() {
        guard let eventIDs = self.unarchiveEventIDs() else { return }
        ParseService.loadMyEvents(eventIDs) { (success, events) -> () in
            if success {
                if let events = events {
                    self.events = events
                }
            } else {
                print("Error - did not retrieve events")
            }
        }
    }
    
    func unarchiveEventIDs() -> [String]? {
//        if let eventIDs = Archiver.retrieveEventIDs() {
//            return eventIDs
        //        }
        var eventIds: [String] = []
        SavedEvent.fetchEvents { (success, events) -> () in
            if success {
                guard let fetchedEvents = events else { return }
                for event in fetchedEvents {
                    eventIds.append(event.eventId!)
                }
            }
        }
        if eventIds.count > 0 {
            return eventIds
        }
        return nil
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(GroupDecisionsTableViewCell.identifier(), forIndexPath: indexPath) as! GroupDecisionsTableViewCell
        if let filledPinImage = UIImage(named: "pin-fill"), emptyPinImage = UIImage(named: "pin-no-fill") {
            cell.pinImageView.image = filledPinImage
            if self.events[indexPath.row].closed == true {
                cell.pinImageView.image = emptyPinImage
            }
        }
        cell.event = self.events[indexPath.row]
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == DecisionDetailViewController.identifier() {
            let destination = segue.destinationViewController as! DecisionDetailViewController
            if let cell = sender as? GroupDecisionsTableViewCell {
                destination.event = cell.event
            }
        }
    }
    
}
