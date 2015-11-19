//
//  CreateEventViewController.swift
//  DeciderApp
//
//  Created by Miles Ranisavljevic on 11/17/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

import UIKit

class CreateEventViewController: UIViewController, UITextFieldDelegate, SearchControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var searchAPIButtonPressed: UIButton!
    @IBOutlet weak var createEventButtonPressed: UIBarButtonItem!
    @IBOutlet weak var selectedVenuesCollectionView: UICollectionView!
    
    var event: Event?
    
    var selectedVenues = [Venue]() {
        didSet {
            print("Got \(self.selectedVenues.count) venues in the create controller!")
            self.selectedVenuesCollectionView.reloadData()
        }
    }
        
    let messageService = MessageService()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        titleTextField.delegate = self
        descriptionTextField.delegate = self
        self.selectedVenuesCollectionView.delegate = self
        self.selectedVenuesCollectionView.dataSource = self
        self.datePicker.minimumDate = NSDate()

        
        checkValidEventParameters()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidEventParameters()
        navigationItem.title = textField.text
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // Disable the Create button while editing.
        createEventButtonPressed.enabled = false
    }
    
    func checkValidEventParameters() {
        // Disable the Create button if the text field is empty.
        let text = titleTextField.text ?? ""
        createEventButtonPressed.enabled = !text.isEmpty
    }
    
    
    //MARK: Custom Functions

    func sendMessage(event: Event, completion: (sent: Bool)->()) {
        if messageService.canSendText() {
            let messageViewController = messageService.configureMessageComposeViewController(event)
            messageService.completion = { (sent) -> () in
                if sent {
                    completion(sent: true)
                } else {
                    completion(sent: false)
                }
            }
            self.presentViewController(messageViewController, animated: true, completion: nil)
        } else {
            print("Can't send message.  Check your settings")
            completion(sent: false)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "searchAPISegue" {
            let destination = segue.destinationViewController as! SearchController
            destination.delegate = self
        }
    }
    
    // MARK: Contacts Picker
    
    
    //MARK: Navigation
    
   


    //MARK: Actions
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func createButtonPressed(sender: UIBarButtonItem) {
        
        guard let title = titleTextField.text, description = descriptionTextField.text else {
            // create an alert
            let alert = UIAlertController(title: "Oh No!", message: "You need to fill out all the information to create an event", preferredStyle: UIAlertControllerStyle.Alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK :)", style: UIAlertActionStyle.Default, handler: nil))
            
            // show the alert
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        let dateTime = datePicker.date
        let venue = Venue(fourSquareID: "12345", name: "Miles' Restaurant", address: "1234 E Somewhere St.", latitude: 47.620510, longitude: -122.349690, imageURL: nil, categories: nil, distance: 123, ratingImageURL: nil, reviewCount: 4511 )
        let venues = [venue]
        
        ParseService.saveEvent(title, eventDescription: description, eventDateTime: dateTime, venues: venues, completion: { (success, event) -> () in
            if success {
                if let event = event {
                    self.sendMessage(event, completion: { (sent) -> () in
                        if sent {
                            Archiver.saveNewEventID(event.eventID)
                            if let navController = self.navigationController {
                                if let parentNavController = navController.presentingViewController as? UINavigationController {
                                    if let groupVC = parentNavController.viewControllers.last as? GroupDecisionsTableViewController {
                                        groupVC.tableView.reloadData()
                                        groupVC.dismissViewControllerAnimated(true, completion: nil)
                                    }
                                }
                            }
                        } else {
                            ParseService.deleteEventWithID(event.eventID)
                        }
                    })
                }
            } else {
                // create an alert
                let alert = UIAlertController(title: "Oh No!", message: "You need to fill out all the information to create an event", preferredStyle: UIAlertControllerStyle.Alert)
                
                // add an action (button)
                alert.addAction(UIAlertAction(title: "OK :)", style: UIAlertActionStyle.Default, handler: nil))
                
                // show the alert
                self.presentViewController(alert, animated: true, completion: nil)
            }
        })
    }
    
    //MARK: UICollectionView Delegate & Datasource Methods
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.selectedVenues.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("SelectedVenuesCell", forIndexPath: indexPath) as! SelectedVenuesCell
        cell.venue = self.selectedVenues[indexPath.row]
        return cell
    }
    
    //MARK: SearchControllerDelegate Method
    
    func didUpdateSelectedVenuesWithVenues(venues: [Venue]?) {
        if let venues = venues {
            self.selectedVenues = venues
        }
    }
    

}
