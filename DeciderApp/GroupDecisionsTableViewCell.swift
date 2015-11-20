//
//  GroupDecisionsTableViewCell.swift
//  DeciderApp
//
//  Created by Miles Ranisavljevic on 11/17/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

import UIKit

class GroupDecisionsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var datetimeLabel: UILabel!
    @IBOutlet weak var pinImageView: UIImageView!
    
    class func identifier() -> String {
        return "GroupDecisionsTableViewCell"
    }
    
    var event: Event? {
        didSet {
            guard let event = self.event else { return }
            self.titleLabel.text = event.eventTitle
            self.descriptionLabel.text = event.eventDescription
            self.datetimeLabel.text = NSDateFormatter.localizedStringFromDate(event.eventDateTime, dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
            self.descriptionLabel.text = event.eventDescription
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
