//
//  MFMessageService.swift
//  DeciderApp
//
//  Created by Miles Ranisavljevic on 11/17/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

import Foundation
import MessageUI

class MessageService: NSObject, MFMessageComposeViewControllerDelegate {
    
    func canSendText() -> Bool {
        return MFMessageComposeViewController.canSendText()
    }
    
    func configureMessageComposeViewController(event: Event) -> MFMessageComposeViewController {
        let messageComposeViewController = MFMessageComposeViewController()
        let url = "decider://id=\(event.eventID)"
        messageComposeViewController.messageComposeDelegate = self
        messageComposeViewController.body = "Hey, you've been invited to an event by your Decider friends!  Please follow the link to join: \(url)"
        return messageComposeViewController
    }
    
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

