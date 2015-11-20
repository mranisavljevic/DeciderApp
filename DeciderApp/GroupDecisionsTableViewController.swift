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
        
        // Set up the refresh control
        self.setupRefreshControl()
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
        if let eventIDs = Archiver.retrieveEventIDs() {
            return eventIDs
        }
        return nil
    }
    
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
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
    
    //MARK: - Refresh properties
    
    var refreshLoadingView : UIView!
    var refreshColorView : UIView!

    var isRefreshAnimating = false


    
    //MARK: - Refresh control

    
    func setupRefreshControl() {
        
        // Programmatically inserting a UIRefreshControl
        self.refreshControl = UIRefreshControl()
        
        // Setup the color view, which will display the rainbowed background
        self.refreshColorView = UIView(frame: self.refreshControl!.bounds)
        self.refreshColorView.backgroundColor = UIColor.clearColor()
        self.refreshColorView.alpha = 0.30

        // Color the original spinner icon
        self.refreshControl!.tintColor = UIColor.whiteColor()
        
        // Add the loading and colors views to our refresh control
        self.refreshControl!.addSubview(self.refreshColorView)
        
        // Initalize flags
        self.isRefreshAnimating = false;
        
        // When activated, invoke our refresh function
        self.refreshControl?.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func refresh(){
        let delayInSeconds = 2.4;
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)));
        dispatch_after(popTime, dispatch_get_main_queue()) { () -> Void in
            // When done requesting/reloading/processing invoke endRefreshing, to close the control
            self.refreshControl!.endRefreshing()
            print("running")
        }
        // -- FINISHED SOMETHING AWESOME, WOO! --
    }
    
    func resetAnimation() {
        
        // Reset our flags and background color
        self.isRefreshAnimating = false;
        self.refreshColorView.backgroundColor = UIColor.whiteColor()
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        
        // If we're refreshing and the animation is not playing, then play the animation
        if (self.refreshControl!.refreshing && !self.isRefreshAnimating) {
            self.animateRefreshView()
        }
        
    }
    
    func animateRefreshView() {
        
        // Background color to loop through for our color view
        var colorArray = [UIColor.redColor(), UIColor.blueColor(), UIColor.purpleColor(), UIColor.cyanColor(), UIColor.orangeColor(), UIColor.magentaColor()]
        
        // In Swift, static variables must be members of a struct or class
        struct ColorIndex {
            static var colorIndex = 0
        }
        
        // Flag that we are animating
        self.isRefreshAnimating = true;
        
        UIView.animateWithDuration(
            Double(0.3),
            delay: Double(0.0),
            options: UIViewAnimationOptions.CurveLinear,
            animations: {
                // Change the background color
                self.refreshColorView!.backgroundColor = colorArray[ColorIndex.colorIndex]
                ColorIndex.colorIndex = (ColorIndex.colorIndex + 1) % colorArray.count
            },
            completion: { finished in
                // If still refreshing, keep spinning, else reset
                if (self.refreshControl!.refreshing) {
                    self.animateRefreshView()
                }else {
                    self.resetAnimation()
                }
            }
        )
    }
    
}
