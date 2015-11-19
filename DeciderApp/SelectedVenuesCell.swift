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
    
    var venue: Venue? {
        didSet {
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        guard let venue = self.venue else { return }
            FourSquareService.fetchVenueImage(venue.fourSquareID, completion: { (success, data) -> () in
                if success {
                    if let data = data {
                        FourSquareService.fetchImageFromFetchRequest(data, completion: { (success, image) -> () in
                            if success {
                                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                                    self.selectedVenueImageView.image = image
                                })
                            } else {
                                print("Error converting image data to image.")
                            }
                        })
                    }
                } else {
                    print("Error fetching image data.")
                }
            })
        }
    
}
