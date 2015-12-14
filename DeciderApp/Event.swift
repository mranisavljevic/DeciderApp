//
//  Event.swift
//  DeciderApp
//
//  Created by Miles Ranisavljevic on 11/17/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

import Foundation

class Event: NSObject, NSCoding {
    
    let eventID: String
    var eventTitle: String
    var eventDescription: String
    var eventDateTime: NSDate
    var venues: [Venue]
    var finalSelection: Venue?
    var closed: Bool
    
    init(eventID: String, eventTitle: String, eventDescription: String, eventDateTime: NSDate, venues: [Venue],finalSelection: Venue? = nil, closed: Bool = false) {
        self.eventID = eventID
        self.eventTitle = eventTitle
        self.eventDescription = eventDescription
        self.eventDateTime = eventDateTime
        self.venues = venues
        self.finalSelection = finalSelection
        self.closed = closed
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let eventId = aDecoder.decodeObjectForKey("eventId") as? String, eventTitle = aDecoder.decodeObjectForKey("eventTitle") as? String, eventDescription = aDecoder.decodeObjectForKey("eventDescription") as? String, eventDateTime = aDecoder.decodeObjectForKey("eventDateTime") as? NSDate, venues = aDecoder.decodeObjectForKey("venues") as? [Venue], finalSelection = aDecoder.decodeObjectForKey("finalSelection") as? Venue, closed = aDecoder.decodeObjectForKey("closed") as? Bool else { return nil }
        
        self.init(eventID: eventId, eventTitle: eventTitle, eventDescription: eventDescription, eventDateTime: eventDateTime, venues: venues,finalSelection: finalSelection, closed: closed)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.eventID, forKey: "eventId")
        aCoder.encodeObject(self.eventTitle, forKey: "eventTitle")
        aCoder.encodeObject(self.eventDescription, forKey: "eventDescription")
        aCoder.encodeObject(self.eventDateTime, forKey: "eventDateTime")
        aCoder.encodeObject(self.venues, forKey: "venues")
        aCoder.encodeObject(self.finalSelection, forKey: "finalSelection")
        aCoder.encodeObject(self.closed, forKey: "closed")
    }
    
}
