//
//  DecisionDetailCollectionViewCell.swift
//  DeciderApp
//
//  Created by Miles Ranisavljevic on 11/17/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

import UIKit

class DecisionDetailCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var venueNameLabel: UILabel!
    @IBOutlet weak var venueVotesLabel: UILabel!
    @IBOutlet weak var selectionIndicatorLabel: UILabel!
    
    
    class func identifier() -> String {
        return "DecisionDetailCollectionViewCell"
    }
    
    var venue: (String, Int)? {
        didSet {
            guard let venue = self.venue else { return }
            self.venueNameLabel.text = venue.0
            self.venueVotesLabel.text = "\(venue.1)"
        }
    }
    
}
