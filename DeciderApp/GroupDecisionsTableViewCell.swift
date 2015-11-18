//
//  GroupDecisionsTableViewCell.swift
//  DeciderApp
//
//  Created by Miles Ranisavljevic on 11/17/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

import UIKit

class GroupDecisionsTableViewCell: UITableViewCell {
    
    class func identifier() -> String {
        return "GroupDecisionsTableViewCell"
    }
    
    var event: Event? {
        didSet {
            guard let event = self.event else { return }
            print(event)
            self.textLabel?.text = event.eventTitle
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
