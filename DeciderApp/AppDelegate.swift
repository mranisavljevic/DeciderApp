//
//  AppDelegate.swift
//  DeciderApp
//
//  Created by Miles Ranisavljevic on 11/17/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

import UIKit
import Parse
import CoreData

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
    
    func applicationWillTerminate(application: UIApplication) {
        self.saveContext()
    }
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        let stringURL = "\(url)"
        if stringURL.containsString("id=") {
            let parseID = stringURL.stringByReplacingOccurrencesOfString("decider://id=", withString: "")
//            Archiver.saveNewEventID(parseID)
            SavedEvent.saveEvent(parseID, isVoted: false, isMyEvent: false, completion: { (success) -> () in
                //
            })
            displayDetailViewController(parseID)
        } else if stringURL.containsString("final=") {
            let parseID = stringURL.stringByReplacingOccurrencesOfString("decider://final=", withString: "")
//            Archiver.saveNewEventID(parseID)
            SavedEvent.fetchEventWithId(parseID, completion: { (success, savedEvent) -> () in
                if savedEvent == nil {
                    SavedEvent.saveEvent(parseID, isVoted: false, isMyEvent: false, completion: { (success) -> () in
                        //
                    })
                }
            })
            self.displayFinalSelectionViewController(parseID)
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
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "uk.co.plymouthsoftware.core_data" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("DeciderCoreDataModel", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("DeciderApp")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "Error", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
}
