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
        Parse.setApplicationId("eAvAPVVpjSwOP9Phyzc7mmbPrAXkWOxLNbc8ZagC", clientKey: "qI4InWZyw7fPtkkJnDpLsjPPK7ni8o2MeAsMduWC")
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
//                        detailVC.performSegueWithIdentifier("FinalSelectionViewController", sender: self)
                    }
                })
            }
        }
    }


}

