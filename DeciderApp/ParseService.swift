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
    
    class func saveEvent(eventTitle: String, eventDescription: String, eventDateTime: NSDate, venues: [String : Int], groupPhoneNumbers: [String], completion: (success: Bool, event: Event?)->()) {
        let eventObject = PFObject(className: "Event")
        eventObject["title"] = eventTitle
        eventObject["descripton"] = eventDescription
        eventObject["dateTime"] = eventDateTime
        eventObject["venues"] = venues
        eventObject["phoneNumbers"] = groupPhoneNumbers
        eventObject.saveInBackgroundWithBlock { (success, error) -> Void in
            if success {
                let query = PFQuery(className: "Event")
                query.getFirstObjectInBackgroundWithBlock({ (object, error) -> Void in
                    if let object = object {
                        guard let id = object.objectId else { return }
                        if let title = object["title"] as? String, description = object["description"] as? String, dateTime = object["dateTime"] as? NSDate, venues = object["venues"] as? [String : Int], phones = object["phoneNumbers"] as? [String] {
                            let event = Event(eventID: id, eventTitle: title, eventDescription: description, eventDateTime: dateTime, venues: venues, groupPhoneNumbers: phones)
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
                if let title = object["title"] as? String, description = object["description"] as? String, dateTime = object["dateTime"] as? NSDate, venues = object["venues"] as? [String : Int], phones = object["phoneNumbers"] as? [String] {
                    let event = Event(eventID: id, eventTitle: title, eventDescription: description, eventDateTime: dateTime, venues: venues, groupPhoneNumbers: phones)
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
    
}
