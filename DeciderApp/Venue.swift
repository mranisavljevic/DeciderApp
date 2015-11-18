//
//  Venue.swift
//  DeciderApp
//
//  Created by Matthew Weintrub on 11/18/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

import UIKit

class Venue: NSObject {
    let name: String?
    let address: String?
    let imageURL: NSURL?
    let categories: String?
    let distance: String?
    let ratingImageURL: NSURL?
    let reviewCount: Int?
    
    init(name: String, address: String, imageURL: NSURL, categories: String, distance: String, ratingImageURL: NSURL, reviewCount: Int){
        self.name = name
        self.address = address
        self.imageURL = imageURL
        self.categories = categories
        self.distance = distance
        self.ratingImageURL = ratingImageURL
        self.reviewCount = reviewCount
    }
    

//    init(dictionary: NSDictionary) {
//        name = dictionary["name"] as? String
//        
//        let imageURLString = dictionary["image_url"] as? String
//        if imageURLString != nil {
//            imageURL = NSURL(string: imageURLString!)!
//        } else {
//            imageURL = nil
//        }
//        
//        let location = dictionary["location"] as? NSDictionary
//        var address = ""
//        if location != nil {
//            let addressArray = location!["address"] as? NSArray
//            if addressArray != nil && addressArray!.count > 0 {
//                address = addressArray![0] as! String
//            }
//            
//            let neighborhoods = location!["neighborhoods"] as? NSArray
//            if neighborhoods != nil && neighborhoods!.count > 0 {
//                if !address.isEmpty {
//                    address += ", "
//                }
//                address += neighborhoods![0] as! String
//            }
//        }
//        self.address = address
//        
//        let categoriesArray = dictionary["categories"] as? [[String]]
//        if categoriesArray != nil {
//            var categoryNames = [String]()
//            for category in categoriesArray! {
//                let categoryName = category[0]
//                categoryNames.append(categoryName)
//            }
//            categories = categoryNames.joinWithSeparator(", ")
//        } else {
//            categories = nil
//        }
//        
//        let distanceMeters = dictionary["distance"] as? NSNumber
//        if distanceMeters != nil {
//            let milesPerMeter = 0.000621371
//            distance = String(format: "%.2f mi", milesPerMeter * distanceMeters!.doubleValue)
//        } else {
//            distance = nil
//        }
//        
//        let ratingImageURLString = dictionary["rating_img_url_large"] as? String
//        if ratingImageURLString != nil {
//            ratingImageURL = NSURL(string: ratingImageURLString!)
//        } else {
//            ratingImageURL = nil
//        }
//        
//        reviewCount = dictionary["review_count"] as? NSNumber
//    }
//    
//    class func venues(array array: [NSDictionary]) -> [Venue] {
//        var venues = [Venue]()
//        for dictionary in array {
//            let aVenue = Venue(dictionary: dictionary)
//            venues.append(aVenue)
//        }
//        return venues
//    }

}
