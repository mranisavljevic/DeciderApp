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
    @IBOutlet weak var searchAPIButtonPressed: UIButton!
    @IBOutlet weak var createEventButtonPressed: UIBarButtonItem!
    
    var event: Event?
        
    let messageService = MessageService()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        titleTextField.delegate = self
        descriptionTextField.delegate = self

        
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

    func sendMessage(event: Event) {
        if messageService.canSendText() {
            let messageViewController = messageService.configureMessageComposeViewController(event)
            self.presentViewController(messageViewController, animated: true, completion: nil)
        } else {
            print("Can't send message.  Check your settings")
        }
    }
    
    // MARK: Contacts Picker
    
    
    //MARK: Navigation
    
   


    //MARK: Actions
    
    @IBAction func cancelButtonPressed(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func createButtonPressed(sender: UIBarButtonItem) {
    
            let title = titleTextField.text!
            let description = descriptionTextField.text!
            let dateTime = datePicker.date
            let venues = ["mcdonalds":1,"dumbos":1,"tacos":1,"teds":1]
            let phoneNumbers = ["2147081160","2147081160","2147081160"]
            
            ParseService.saveEvent(title, eventDescription: description, eventDateTime: dateTime, venues: venues, groupPhoneNumbers: phoneNumbers, completion: { (success, event) -> () in
                
                if success {
                    
                    let event = self.event
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                    
                    
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
    

}
