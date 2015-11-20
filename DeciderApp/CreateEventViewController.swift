//
//  CreateEventViewController.swift
//  DeciderApp
//
//  Created by Miles Ranisavljevic on 11/17/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

import UIKit

class CreateEventViewController: UIViewController, UITextFieldDelegate, SearchControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
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
            self.selectedVenuesCollectionView.reloadData()
            for _ in 0..<self.selectedVenues.count {
                self.selectedVenueImages.append(nil)
            }
        }
    
    }
    
    var selectedVenueImages = [UIImage?]()
        
    let messageService = MessageService()

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        checkValidEventParameters()
        navigationItem.title = textField.text
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        createEventButtonPressed.enabled = false
    }
    
    func checkValidEventParameters() {
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
    
    //MARK: Actions
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func createButtonPressed(sender: UIBarButtonItem) {
        
        guard let title = titleTextField.text, description = descriptionTextField.text else {
            let alert = UIAlertController(title: "Oh No!", message: "You need to fill out all the information to create an event", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK :)", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        let dateTime = datePicker.date
        let venues = self.selectedVenues
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
                let alert = UIAlertController(title: "Oh No!", message: "You need to fill out all the information to create an event", preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK :)", style: UIAlertActionStyle.Default, handler: nil))
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
        cell.selectedVenueImageView.image = nil
        cell.venue = self.selectedVenues[indexPath.row]
        if let image = self.selectedVenueImages[indexPath.row] {
            cell.image = image
        } else {
            FourSquareService.fetchVenueImage(self.selectedVenues[indexPath.row].fourSquareID, completion: { (success, data) -> () in
                if success {
                    if let data = data {
                        FourSquareService.fetchImageFromFetchRequest(data, completion: { (success, image) -> () in
                            if success {
                                guard let image = image else { return }
                                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                                    cell.image = image
                                    self.selectedVenueImages[indexPath.row] = image
                                })
                            } else {
                                cell.image = UIImage(named: "venue")
                            }
                        })
                    }
                } else {
                    cell.image = UIImage(named: "venue")
                    print("Error fetching image data.")
                }
            })
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(100, 100)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10.0
    }
    
    //MARK: SearchControllerDelegate Method
    
    func didUpdateSelectedVenuesWithVenues(venues: [Venue]?) {
        if let venues = venues {
            self.selectedVenues = venues
        }
    }
    

}
