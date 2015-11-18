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
    var venues: [String : Int]
    
    init(eventID: String, eventTitle: String, eventDescription: String, eventDateTime: NSDate, venues: [String : Int]) {
        self.eventID = eventID
        self.eventTitle = eventTitle
        self.eventDescription = eventDescription
        self.eventDateTime = eventDateTime
        self.venues = venues
    }
    
}
