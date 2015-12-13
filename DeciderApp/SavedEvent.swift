//
//  SavedEvent.swift
//  DeciderApp
//
//  Created by Miles Ranisavljevic on 12/11/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

import UIKit
import CoreData


class SavedEvent: NSManagedObject {
    
    class func saveEvent(event: Event, isVoted:Bool, isMyEvent: Bool, completion: (success: Bool)->()) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        guard let newEvent = NSEntityDescription.insertNewObjectForEntityForName("SavedEvent", inManagedObjectContext: context) as? SavedEvent else { return }
        newEvent.event = event
        newEvent.eventId = event.eventID
        newEvent.isVoted = isVoted
        newEvent.isMyEvent = isMyEvent
        do {
            try context.save()
        } catch {
            completion(success: false)
        }
        SavedEvent.fetchEventWithId(event.eventID) { (success, savedEvent) -> () in
            completion(success: success)
        }
    }
    
    class func fetchEventWithId(eventId: String, completion: (success: Bool, savedEvent: SavedEvent?)->()) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        let eventFetch = NSFetchRequest(entityName: "SavedEvent")
        eventFetch.predicate = NSPredicate(format: "eventId == %@", eventId)
        do {
            guard let fetchedEvents = try context.executeFetchRequest(eventFetch) as? [SavedEvent] else {
                completion(success: false, savedEvent: nil)
                return
            }
            print(fetchedEvents)
            if let fetchedEvent = fetchedEvents.first {
                completion(success: true, savedEvent: fetchedEvent)
            }
        } catch {
            completion(success: false, savedEvent: nil)
            return
        }
    }
    
    class func fetchEvents(completion: (success: Bool, events: [SavedEvent]?)->()) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        let eventFetch = NSFetchRequest(entityName: "SavedEvent")
        do {
            guard let fetchedEvents = try context.executeFetchRequest(eventFetch) as? [SavedEvent] else {
                completion(success: false, events: nil)
                return
            }
            completion(success: true, events: fetchedEvents)
        } catch {
            completion(success: false, events: nil)
            return
        }
    }
    
    class func voteEventWithId(eventId: String, completion: (success: Bool) -> ()) {
        SavedEvent.fetchEventWithId(eventId) { (success, savedEvent) -> () in
            guard let event = savedEvent else {
                completion(success: false)
                return
            }
            event.isVoted = true
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let context = appDelegate.managedObjectContext
            do {
                try context.save()
                completion(success: true)
                return
            } catch {
                completion(success: false)
                return
            }
        }
    }
    
    class func fetchVotedEvents(completion: (success: Bool, events: [SavedEvent]?)->()) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        let eventFetch = NSFetchRequest(entityName: "SavedEvent")
        eventFetch.predicate = NSPredicate(format: "isVoted == %@", true)
        do {
            guard let fetchedEvents = try context.executeFetchRequest(eventFetch) as? [SavedEvent] else {
                completion(success: false, events: nil)
                return
            }
            completion(success: true, events: fetchedEvents)
        } catch {
            completion(success: false, events: nil)
            return
        }
    }
}
