//
//  SavedEvent+CoreDataProperties.swift
//  DeciderApp
//
//  Created by Miles Ranisavljevic on 12/11/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension SavedEvent {

    @NSManaged var isMyEvent: NSNumber?
    @NSManaged var isVoted: NSNumber?
    @NSManaged var event: Event?

}
