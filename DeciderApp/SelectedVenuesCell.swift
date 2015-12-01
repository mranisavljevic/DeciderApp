//
//  SelectedVenuesCell.swift
//  DeciderApp
//
//  Created by Matthew Weintrub on 11/19/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

import UIKit

class SelectedVenuesCell: UICollectionViewCell {
    
    @IBOutlet weak var selectedVenueImageView: UIImageView!
    @IBOutlet weak var selectedVenueNameLabel: UILabel!
    
    var venue: Venue? {
        didSet {
            guard let venue = self.venue else { return }
            self.selectedVenueNameLabel.text = venue.name == "Dummy" ? "" : venue.name
            self.layoutSubviews()
        }
    }
    
    var image: UIImage? {
        didSet {
            guard let image = self.image else { return }
            self.selectedVenueImageView.image = image
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
