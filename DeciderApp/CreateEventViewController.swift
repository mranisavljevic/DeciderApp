//
//  CreateEventViewController.swift
//  DeciderApp
//
//  Created by Miles Ranisavljevic on 11/17/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

import UIKit
import MessageUI

class CreateEventViewController: MFMessageComposeViewController, MFMessageComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func sendInvitationMessage(event: Event, completion: ()->()) {
        if MFMessageComposeViewController.canSendText() {
            
        }
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        //
    }

}
