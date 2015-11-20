//
//  FinalSelectionViewController.swift
//  DeciderApp
//
//  Created by Miles Ranisavljevic on 11/19/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

import UIKit

class FinalSelectionViewController: UIViewController {
    
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventImageLabel: UIImageView!
    @IBOutlet weak var eventAddressLabel: UILabel!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    
    
    class func identifier() -> String {
        return "FinalSelectionViewController"
    }
    
    var event: Event? {
        didSet {
            guard let event = self.event else { return }
            self.eventTitleLabel.text = event.eventTitle
            self.eventDescriptionLabel.text = event.eventDescription
            self.eventDateLabel.text = NSDateFormatter.localizedStringFromDate(event.eventDateTime, dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
        }
    }
    
    var venue: Venue? {
        didSet {
            guard let venue = self.venue else { return }
            self.eventNameLabel.text = venue.name
            self.eventAddressLabel.text = venue.address
            FourSquareService.fetchVenueImage(venue.fourSquareID) { (success, data) -> () in
                if success {
                    if let data = data {
                        FourSquareService.fetchImageFromFetchRequest(data, completion: { (success, image) -> () in
                            if success {
                                if let image = image {
                                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                                        self.eventImageLabel.image = image
                                    })
                                }
                            }
                        })
                    }
                }
            }
        }
    }
    
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
    
    @IBAction func dismissButtonPressed(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

}
