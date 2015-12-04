//
//  AppDelegate.swift
//  DeciderApp
//
//  Created by Miles Ranisavljevic on 11/17/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        UINavigationBar.appearance().tintColor = UIColor.darkPurpleColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        
        Parse.setApplicationId("eAvAPVVpjSwOP9Phyzc7mmbPrAXkWOxLNbc8ZagC", clientKey: "qI4InWZyw7fPtkkJnDpLsjPPK7ni8o2MeAsMduWC")
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        return true
    }
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        let stringURL = "\(url)"
        if stringURL.containsString("id=") {
            let parseID = stringURL.stringByReplacingOccurrencesOfString("decider://id=", withString: "")
            Archiver.saveNewEventID(parseID)
            displayDetailViewController(parseID)
        } else if stringURL.containsString("final=") {
            let parseID = stringURL.stringByReplacingOccurrencesOfString("decider://final=", withString: "")
            Archiver.saveNewEventID(parseID)
            displayFinalSelectionViewController(parseID)
        }
        return true
    }
    
    func displayDetailViewController(eventID: String) {
        if let navController = self.window?.rootViewController as? UINavigationController, storyboard = navController.storyboard {
            if let homeVC = storyboard.instantiateViewControllerWithIdentifier("GroupDecisionsTableViewController") as? GroupDecisionsTableViewController {
                let detailVC = storyboard.instantiateViewControllerWithIdentifier("DecisionDetailViewController") as! DecisionDetailViewController
                ParseService.loadEvent(eventID, completion: { (success, event) -> () in
                    if success {
                        guard let event = event else { return }
                        detailVC.event = event
                        navController.pushViewController(homeVC, animated: true)
                        navController.pushViewController(detailVC, animated: true)
                    }
                })
            }
        }
    }
    
    func displayFinalSelectionViewController(eventID: String) {
        if let navController = self.window?.rootViewController as? UINavigationController, storyboard = navController.storyboard {
            if let homeVC = storyboard.instantiateViewControllerWithIdentifier("GroupDecisionsTableViewController") as? GroupDecisionsTableViewController {
                let detailVC = storyboard.instantiateViewControllerWithIdentifier("DecisionDetailViewController") as! DecisionDetailViewController
                let finalVC = storyboard.instantiateViewControllerWithIdentifier("FinalSelectionViewController") as! FinalSelectionViewController
                ParseService.loadEvent(eventID, completion: { (success, event) -> () in
                    if success {
                        guard let event = event else { return }
                        detailVC.event = event
                        finalVC.eventID = event.eventID
                        navController.pushViewController(homeVC, animated: true)
                        navController.pushViewController(detailVC, animated: true)
                    }
                })
            }
        }
    }
}
