//
//  CreateEventViewController.swift
//  DeciderApp
//
//  Created by Miles Ranisavljevic on 11/17/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

import UIKit

class CreateEventViewController: UIViewController {
    
    let messageService = MessageService()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func sendMessage(event: Event) {
        if messageService.canSendText() {
            let messageViewController = messageService.configureMessageComposeViewController(event)
            self.presentViewController(messageViewController, animated: true, completion: nil)
        } else {
            print("Can't send message.  Check your settings")
        }
    }

}
