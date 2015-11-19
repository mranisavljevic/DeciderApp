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
        
        FourSquareService.searchVenues("Taco") { (success, data) -> () in
            if let data = data {
                FourSquareService.parseVenueResponse(data, completion: { (success, json) -> () in
                    if let json = json {
                        print(json)
                    }
                })
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        fetchMyEvents()
        
        // Set up the refresh control
//        self.setupRefreshControl()
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
    
//    //MARK: - Refresh properties
//    
//    var refreshLoadingView : UIView!
//    var refreshColorView : UIView!
//    var compass_background : UIImageView!
//    var compass_spinner : UIImageView!
//    
//    var isRefreshAnimating = false
//    
//    //MARK: - Refresh control
//
//    
//    func setupRefreshControl() {
//        
//        // Programmatically inserting a UIRefreshControl
//        self.refreshControl = UIRefreshControl()
//        
//        // Setup the loading view, which will hold the moving graphics
//        self.refreshLoadingView = UIView(frame: self.refreshControl!.bounds)
//        self.refreshLoadingView.backgroundColor = UIColor.clearColor()
//        
//        // Setup the color view, which will display the rainbowed background
//        self.refreshColorView = UIView(frame: self.refreshControl!.bounds)
//        self.refreshColorView.backgroundColor = UIColor.clearColor()
//        self.refreshColorView.alpha = 0.30
//        
//        // Create the graphic image views
//        compass_background = UIImageView(image: UIImage(named: "compass_background.png"))
//        self.compass_spinner = UIImageView(image: UIImage(named: "compass_spinner.png"))
//        
//        // Add the graphics to the loading view
//        self.refreshLoadingView.addSubview(self.compass_background)
//        self.refreshLoadingView.addSubview(self.compass_spinner)
//        
//        // Clip so the graphics don't stick out
//        self.refreshLoadingView.clipsToBounds = true;
//        
//        // Hide the original spinner icon
//        self.refreshControl!.tintColor = UIColor.clearColor()
//        
//        // Add the loading and colors views to our refresh control
//        self.refreshControl!.addSubview(self.refreshColorView)
//        self.refreshControl!.addSubview(self.refreshLoadingView)
//        
//        // Initalize flags
//        self.isRefreshAnimating = false;
//        
//        // When activated, invoke our refresh function
//        self.refreshControl?.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
//    }
//    
//    func refresh(){
//        
//        // -- DO SOMETHING AWESOME (... or just wait 3 seconds) --
//        // This is where you'll make requests to an API, reload data, or process information
//        let delayInSeconds = 3.0;
//        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)));
//        dispatch_after(popTime, dispatch_get_main_queue()) { () -> Void in
//            // When done requesting/reloading/processing invoke endRefreshing, to close the control
//            self.refreshControl!.endRefreshing()
//        }
//        // -- FINISHED SOMETHING AWESOME, WOO! --
//    }
//    
//    func resetAnimation() {
//        
//        // Reset our flags and }background color
//        self.isRefreshAnimating = false;
//        self.refreshColorView.backgroundColor = UIColor.clearColor()
//    }
//    
//    override func scrollViewDidScroll(scrollView: UIScrollView) {
//        
//        // Get the current size of the refresh controller
//        var refreshBounds = self.refreshControl!.bounds;
//        
//        // Distance the table has been pulled >= 0
//        let pullDistance = max(0.0, -self.refreshControl!.frame.origin.y);
//        
//        // Half the width of the table
//        let midX = self.tableView.frame.size.width / 2.0;
//    
//        
//        // Calculate the pull ratio, between 0.0-1.0
//        let pullRatio = min( max(pullDistance, 0.0), 100.0) / 100.0;
//       
//        
//        // Set the encompassing view's frames
//        refreshBounds.size.height = pullDistance;
//        
//        self.refreshColorView.frame = refreshBounds;
//        self.refreshLoadingView.frame = refreshBounds;
//        
//        // If we're refreshing and the animation is not playing, then play the animation
//        if (self.refreshControl!.refreshing && !self.isRefreshAnimating) {
//            self.animateRefreshView()
//        }
//        
//    }
//    
//    func animateRefreshView() {
//        
//        // Background color to loop through for our color view
//        var colorArray = [UIColor.redColor(), UIColor.blueColor(), UIColor.purpleColor(), UIColor.cyanColor(), UIColor.orangeColor(), UIColor.magentaColor()]
//        
//        // In Swift, static variables must be members of a struct or class
//        struct ColorIndex {
//            static var colorIndex = 0
//        }
//        
//        // Flag that we are animating
//        self.isRefreshAnimating = true;
//        
//        UIView.animateWithDuration(
//            Double(0.3),
//            delay: Double(0.0),
//            options: UIViewAnimationOptions.CurveLinear,
//            animations: {
//                // Rotate the spinner by M_PI_2 = PI/2 = 90 degrees
//                self.compass_spinner.transform = CGAffineTransformRotate(self.compass_spinner.transform, CGFloat(M_PI_2))
//                
//                // Change the background color
//                self.refreshColorView!.backgroundColor = colorArray[ColorIndex.colorIndex]
//                ColorIndex.colorIndex = (ColorIndex.colorIndex + 1) % colorArray.count
//            },
//            completion: { finished in
//                // If still refreshing, keep spinning, else reset
//                if (self.refreshControl!.refreshing) {
//                    self.animateRefreshView()
//                }else {
//                    self.resetAnimation()
//                }
//            }
//        )
//    }
    
}
