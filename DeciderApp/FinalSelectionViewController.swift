//
//  FinalSelectionViewController.swift
//  DeciderApp
//
//  Created by Miles Ranisavljevic on 11/19/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

import UIKit

class FinalSelectionViewController: UIViewController {
    
    class func identifier() -> String {
        return "FinalSelectionViewController"
    }
    
    var event: Event?
    
    var venue: Venue?
    
    var eventID: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setUpView() {
        guard let eventID = self.eventID else { return }
        ParseService.loadEvent(eventID) { (success, event) -> () in
            if success {
                if let loadedEvent = event {
                    if let loadedVenue = loadedEvent.finalSelection {
                        self.event = loadedEvent
                        self.venue = loadedVenue
                    }
                }
            } else {
                print("Error loading event.")
            }
        }
    }

}
