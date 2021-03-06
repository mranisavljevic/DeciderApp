//
//  Event.swift
//  DeciderApp
//
//  Created by Miles Ranisavljevic on 11/17/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

import Foundation

class Event {
    
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
    
}
