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
    
    class func saveEvent(eventTitle: String, eventDescription: String, eventDateTime: NSDate, venues: [Venue], completion: (success: Bool, event: Event?)->()) {
        let eventObject = PFObject(className: "Event")
        eventObject["title"] = eventTitle
        eventObject["description"] = eventDescription
        eventObject["dateTime"] = eventDateTime
        var venueDictionaries = [[String : AnyObject]]()
        for venue in venues {
            venueDictionaries.append(venue.convertToDictionary())
        }
        eventObject["venueList"] = venueDictionaries
        eventObject["closed"] = false
        eventObject.saveInBackgroundWithBlock { (success, error) -> Void in
            if success {
                let query = PFQuery(className: "Event")
                query.whereKey("dateTime", equalTo: eventDateTime)
                query.getFirstObjectInBackgroundWithBlock({ (object, error) -> Void in
                    if let object = object {
                        guard let id = object.objectId else { return }
                        if let title = object["title"] as? String, description = object["description"] as? String, dateTime = object["dateTime"] as? NSDate, venues = object["venueList"] as? [[String : AnyObject]], closed = object["closed"] as? Bool {
                            var convertedVenues = [Venue]()
                            for venue in venues {
                                if let convertedVenue = Venue.convertFromDictionary(venue) {
                                    convertedVenues.append(convertedVenue)
                                }
                            }
                            let event = Event(eventID: id, eventTitle: title, eventDescription: description, eventDateTime: dateTime, venues: convertedVenues, closed: closed)
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
                if let title = object["title"] as? String, description = object["description"] as? String, dateTime = object["dateTime"] as? NSDate, venues = object["venueList"] as? [[String : AnyObject]], closed = object["closed"] as? Bool {
                    var convertedVenues = [Venue]()
                    for venue in venues {
                        if let convertedVenue = Venue.convertFromDictionary(venue) {
                            convertedVenues.append(convertedVenue)
                        }
                    }
                    let event = Event(eventID: id, eventTitle: title, eventDescription: description, eventDateTime: dateTime, venues: convertedVenues, closed: closed)
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
                    if let title = event["title"] as? String, description = event["description"] as? String, dateTime = event["dateTime"] as? NSDate, venues = event["venueList"] as? [[String : AnyObject]], closed = event["closed"] as? Bool {
                        var convertedVenues = [Venue]()
                        for venue in venues {
                            if let convertedVenue = Venue.convertFromDictionary(venue) {
                                convertedVenues.append(convertedVenue)
                            }
                        }
                            let parsedEvent = Event(eventID: id, eventTitle: title, eventDescription: description, eventDateTime: dateTime, venues: convertedVenues, closed: closed)
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
    
    class func updateVotes(eventID: String, venues: [(String, Int)], completion: (success: Bool)->()) {
        let query = PFQuery(className: "Event")
        query.whereKey("objectId", equalTo: eventID)
        query.getFirstObjectInBackgroundWithBlock { (object, error) -> Void in
            if let event = object {
                guard let eventVenues = event["venueList"] as? [[String : AnyObject]] else { return }
                var venueObject = [Venue]()
                var updatedVenues = [Venue]()
                for eventVenue in eventVenues {
                    if let venue = Venue.convertFromDictionary(eventVenue) {
                        venueObject.append(venue)
                    }
                }
                for venue in venues {
                    for venueObjectItem in venueObject {
                        if venue.0 == venueObjectItem.name {
                            venueObjectItem.votes = venue.1
                            updatedVenues.append(venueObjectItem)
                        }
                    }
                }
                var venueDictionaries = [[String : AnyObject]]()
                for venueOb in venueObject {
                    venueDictionaries.append(venueOb.convertToDictionary())
                }
                let parseObject = PFObject(className: "Event")
                parseObject.objectId = eventID
                parseObject.setValue(venueDictionaries, forKey: "venueList")
                parseObject.saveInBackgroundWithBlock { (success, error) -> Void in
                    if success {
                        completion(success: true)
                    } else {
                        if let error = error {
                            print("Error: \(error.code)")
                        }
                        completion(success: false)
                    }
                }
            }
            if let _ = error {
                print("Error fetching object")
            }
        }
    }
    
    class func closeEvent(eventID: String, completion: (success: Bool)->()) {
        let parseObject = PFObject(className: "Event")
        parseObject.objectId = eventID
        parseObject.setValue(true, forKey: "closed")
        parseObject.saveInBackgroundWithBlock { (success, error) -> Void in
            if success {
                completion(success: true)
            } else {
                if let error = error {
                    print("Error closing event with code: \(error.code)")
                }
                completion(success: false)
            }
        }
    }
    
}
