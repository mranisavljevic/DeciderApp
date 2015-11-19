//
//  MFMessageService.swift
//  DeciderApp
//
//  Created by Miles Ranisavljevic on 11/17/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

import Foundation
import MessageUI

typealias MessageServiceCompletion = (sent: Bool)->()

class MessageService: NSObject, MFMessageComposeViewControllerDelegate {
    
    var completion: MessageServiceCompletion?
    
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
    
    func sendFinalMessageComposeViewController(event: Event) -> MFMessageComposeViewController {
        let messageComposeViewController = MFMessageComposeViewController()
        let url = "decider://final=\(event.eventID)"
        messageComposeViewController.messageComposeDelegate = self
        messageComposeViewController.body = "Your Decider friends have chosen a place to go! Please follow the link to find out more: \(url)"
        return messageComposeViewController
    }
    
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        if let completion = self.completion {
            switch result {
            case MessageComposeResultSent:
                completion(sent: true)
            default:
                completion(sent: false)
            }
        }
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

