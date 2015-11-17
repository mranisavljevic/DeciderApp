//
//  CreateEventViewController.swift
//  DeciderApp
//
//  Created by Miles Ranisavljevic on 11/17/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

import UIKit

class CreateEventViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: Properties
    
    @IBOutlet weak var addFriendsButtonPressed: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    var event: Event?
        
    let messageService = MessageService()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        titleTextField.delegate = self
        
        // Set up views if editing an existing Meal.
        if let event = event {
            titleTextField.text = event.eventTitle
            descriptionTextField.text = event.eventDescription
            datePicker.date = event.eventDateTime
            
        }
        // Enable the Save button only if the text field has a valid Meal name.
//        checkValidEventParameters()

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
//        checkValidEventParameters()
        navigationItem.title = textField.text
    }
    
//    func textFieldDidBeginEditing(textField: UITextField) {
//        // Disable the Create button while editing.
//        createEventButtonPressed.enabled = false
//    }
//    
//    func checkValidEventParameters() {
//        // Disable the Create button if the text field is empty.
//        let text = titleTextField.text ?? ""
//        createEventButtonPressed.enabled = !text.isEmpty
//    }
    
    
    //MARK: Custom Functions

    func sendMessage(event: Event) {
        if messageService.canSendText() {
            let messageViewController = messageService.configureMessageComposeViewController(event)
            self.presentViewController(messageViewController, animated: true, completion: nil)
        } else {
            print("Can't send message.  Check your settings")
        }
    }
    
    // MARK: Contacts Picker
    
    
    
//    // This method lets you configure a view controller before it's presented.
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if createEventButtonPressed === sender {
//            let name = titleTextField.text ?? ""
//            let description = descriptionTextField.text ?? ""
//            
//            // Set the event to be passed to GroupDecisionTableViewController after the unwind segue.
//            event = Event(eventID: String, eventTitle: String, eventDescription: String, eventDateTime: NSDate, venues: [String : Int], groupPhoneNumbers: [String])        }
//    }
    

    //MARK: Actions
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func createEventButtonPressed(sender: UIBarButtonItem) {
        
    }
    
}
