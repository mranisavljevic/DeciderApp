//
//  SearchCell.swift
//  DeciderApp
//
//  Created by Matthew Weintrub on 11/18/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var reviewCountLabel: UILabel!
    @IBOutlet weak var checkboxButton: Checkbox!
    
    var venue: Venue? {
        didSet {
            guard let venue = self.venue else {return}
            guard let address = venue.address, distance = venue.distance, reviews = venue.reviewCount else { return }
            nameLabel.text = venue.name
            addressLabel.text = address
            distanceLabel.text = "\(String(format: "%.2f", Float(distance) * 0.00062)) mi"
//            let string = String(format: "%.2f", Float(distance) * 0.00062)
            
            
//            println(String(format: "%.3f", totalWorkTimeInHours))
            
            reviewCountLabel.text = "\(reviews) Reviews"
            FourSquareService.fetchVenueImage(venue.fourSquareID) { (success, data) -> () in
                if let data = data {
                    FourSquareService.fetchImageFromFetchRequest(data, completion: { (success, image) -> () in
                        let queue = NSOperationQueue.mainQueue()
                        queue.addOperationWithBlock({ () -> Void in
                            if let image = image {
                                self.thumbnailImageView.image = image
                            }
                        })
                    })
                }
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        thumbnailImageView.layer.cornerRadius = 5
        thumbnailImageView.clipsToBounds = true
        
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
        
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
