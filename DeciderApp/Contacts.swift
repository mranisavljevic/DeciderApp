//
//  Contacts.swift
//  DeciderApp
//
//  Created by Matthew Weintrub on 11/17/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

import Foundation

class Contacts{
    
}


////MARK: Properties
//var contacts = [CNContact]()
//
//override func viewDidLoad() {
//    super.viewDidLoad()
//    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
//        self.contacts = self.findContacts()
//        
//        dispatch_async(dispatch_get_main_queue()) {
//            self.tableView!.reloadData()
//        }
//    }
//}
//
//override func viewWillAppear(animated: Bool) {
//    super.viewWillAppear(animated)
//}
//
////MARK: Contacts fetch
//
//func findContacts() -> [CNContact] {
//    let store = CNContactStore()
//    
//    let keysToFetch = [CNContactFormatter.descriptorForRequiredKeysForStyle(.FullName),
//        CNContactImageDataKey,
//        CNContactPhoneNumbersKey]
//    
//    let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch)
//    
//    var contacts = [CNContact]()
//    
//    do {
//        try store.enumerateContactsWithFetchRequest(fetchRequest, usingBlock: { (let contact, let stop) -> Void in
//            contacts.append(contact)
//        })
//    }
//    catch let error as NSError {
//        print(error.localizedDescription)
//    }
//    
//    return contacts
//}
//
//
//// MARK: - Table View
//
//override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//    return 1
//}
//
//override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    return self.contacts.count
//}
//
//override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//    let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
//    
//    let contact = contacts[indexPath.row] as CNContact
//    cell.textLabel!.text = "\(contact.givenName) \(contact.familyName)"
//    return cell
//}
//
//// MARK: - Contacts Picker
//
//@IBAction func showContactsPicker(sender: UIBarButtonItem) {
//    let contactPicker = CNContactPickerViewController()
//    contactPicker.delegate = self
//    contactPicker.displayedPropertyKeys = [CNContactPhoneNumbersKey]
//    
//    self.presentViewController(contactPicker, animated: true, completion: nil)
//}
//
//func contactPicker(picker: CNContactPickerViewController, didSelectContactProperty contactProperty: CNContactProperty) {
//    let contact = contactProperty.contact
//    let phoneNumber = contactProperty.value as! CNPhoneNumber
//    
//    print(contact.givenName)
//    print(phoneNumber.stringValue)
//}
