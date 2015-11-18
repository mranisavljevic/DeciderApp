//
//  ParseService.swift
//  DeciderApp
//
//  Created by Miles Ranisavljevic on 11/17/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

import Foundation
import Parse

class ParseService {
    
//    class func saveOneEventForTesting() {
//        let title = "Dinner"
//        let eventDescription = "Let's get dinner after class!"
//        let eventDateTime = NSDate()
//        let venues = ["IHOP":1,"Taco Bell":1,"Burger King":1,"Other Gross Stuff":1]
//        let groupPhones = ["2064272503","5555555555","5551234567"]
//        ParseService.saveEvent(title, eventDescription: eventDescription, eventDateTime: eventDateTime, venues: venues, groupPhoneNumbers: groupPhones) { (success, event) -> () in
//            print("Success: \(success)")
//            print("Error: \(event?.eventID)")
//        }
//    }
    
    class func saveEvent(eventTitle: String, eventDescription: String, eventDateTime: NSDate, venues: [String : Int], completion: (success: Bool, event: Event?)->()) {
        let eventObject = PFObject(className: "Event")
        eventObject["title"] = eventTitle
        eventObject["description"] = eventDescription
        eventObject["dateTime"] = eventDateTime
        eventObject["venues"] = venues
        eventObject.saveInBackgroundWithBlock { (success, error) -> Void in
            if success {
                let query = PFQuery(className: "Event")
                query.whereKey("dateTime", equalTo: eventDateTime)
                query.getFirstObjectInBackgroundWithBlock({ (object, error) -> Void in
                    if let object = object {
                        guard let id = object.objectId else { return }
                        if let title = object["title"] as? String, description = object["description"] as? String, dateTime = object["dateTime"] as? NSDate, venues = object["venues"] as? [String : Int] {
                            let event = Event(eventID: id, eventTitle: title, eventDescription: description, eventDateTime: dateTime, venues: venues)
                            completion(success: true, event: event)
                        }
                    }
                })
            } else {
                if let error = error {
                    print("Error: \(error.code)")
                }
                completion(success: false, event: nil)
            }
        }
    }
    
    class func loadEvent(eventID: String, completion: (success: Bool, event: Event?)->()) {
        let query = PFQuery(className: "Event")
        query.getObjectInBackgroundWithId(eventID) { (object, error) -> Void in
            if let object = object {
                guard let id = object.objectId else { return }
                if let title = object["title"] as? String, description = object["description"] as? String, dateTime = object["dateTime"] as? NSDate, venues = object["venues"] as? [String : Int] {
                    let event = Event(eventID: id, eventTitle: title, eventDescription: description, eventDateTime: dateTime, venues: venues)
                    completion(success: true, event: event)
                }
            } else {
                if let error = error {
                    print("Error: \(error.code)")
                }
                completion(success: false, event: nil)
            }
        }
    }
    
    class func loadEventFromOpenURL(code: String, completion: ()->()) {
        
    }
    
    class func loadMyEvents(eventIDs: [String], completion: (success: Bool, events: [Event]?)->()) {
        var eventsArray = [Event]()
        let query = PFQuery(className: "Event")
        query.whereKey("objectId", containedIn: eventIDs)
//        query.whereKey("dateTime", greaterThanOrEqualTo: NSDate())
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if let events = objects {
                for event in events {
                    guard let id = event.objectId else { return }
                    if let title = event["title"] as? String, description = event["description"] as? String, dateTime = event["dateTime"] as? NSDate, venues = event["venues"] as? [String : Int] {
                            let parsedEvent = Event(eventID: id, eventTitle: title, eventDescription: description, eventDateTime: dateTime, venues: venues)
                            eventsArray.append(parsedEvent)
                    }
                    if eventsArray.count > 0 {
                        completion(success: true, events: eventsArray)
                    }
                }
            } else {
                if let error = error {
                    print("Error: \(error.code)")
                }
                completion(success: false, events: nil)
            }
        }
    }
    
    class func deleteEventWithID(eventID: String) {
        let object = PFObject(className: "Event")
        object.objectId = eventID
        object.deleteInBackground()
    }
    
}
