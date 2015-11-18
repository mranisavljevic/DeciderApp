//
//  ArchiveService.swift
//  DeciderApp
//
//  Created by Miles Ranisavljevic on 11/17/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

import Foundation

class Archiver: NSObject, NSCoding {
    
    let eventIDs: [String]
    
    init(eventIDs: [String]) {
        self.eventIDs = eventIDs
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let eventIDs = aDecoder.decodeObjectForKey("eventIDs") as? [String] else { return nil }
        
        self.init(eventIDs: eventIDs)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.eventIDs, forKey: "eventIDs")
    }
    
    class func retrieveEventIDs() -> [String]? {
        if let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last {
            if let eventIDs = NSKeyedUnarchiver.unarchiveObjectWithFile(path + "/archive") as? [String] {
                return eventIDs
            }
        }
        return nil
    }
    
    class func saveEventIDs(eventIDs: [String]) {
        if let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last {
            NSKeyedArchiver.archiveRootObject(eventIDs, toFile: path + "/archive")
        }
    }
    
}


