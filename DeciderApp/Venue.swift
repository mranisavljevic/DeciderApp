//
//  Venue.swift
//  DeciderApp
//
//  Created by Matthew Weintrub on 11/18/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

import Foundation

final class Venue: NSObject, NSCoding {
    
    let fourSquareID: String
    let name: String
    let address: String?
    let latitude: Double?
    let longitude: Double?
    let imageURL: String?
    let categories: String?
    let distance: Int?
    let ratingImageURL: String?
    let reviewCount: Int?
    var votes: Int
    
    init(fourSquareID: String, name: String, address: String?, latitude: Double?, longitude: Double?, imageURL: String?, categories: String?, distance: Int?, ratingImageURL: String?, reviewCount: Int?, votes: Int = 0) {
        self.fourSquareID = fourSquareID
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.imageURL = imageURL
        self.categories = categories
        self.distance = distance
        self.ratingImageURL = ratingImageURL
        self.reviewCount = reviewCount
        self.votes = votes
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        guard let fourSquareID = aDecoder.decodeObjectForKey("fourSquareID") as? String, name = aDecoder.decodeObjectForKey("name") as? String, address = aDecoder.decodeObjectForKey("address") as? String?, latitude = aDecoder.decodeObjectForKey("latitude") as? Double?, longitude = aDecoder.decodeObjectForKey("longitude") as? Double?, imageURL = aDecoder.decodeObjectForKey("imageURL") as? String?, categories = aDecoder.decodeObjectForKey("categories") as? String?, distance = aDecoder.decodeObjectForKey("distance") as? Int?, ratingImageURL = aDecoder.decodeObjectForKey("ratingImageURL") as? String?, reviewCount = aDecoder.decodeObjectForKey("reviewCount") as? Int?, votes = aDecoder.decodeObjectForKey("votes") as? Int else { return nil }
        
        self.init(fourSquareID: fourSquareID, name: name, address: address, latitude: latitude, longitude: longitude, imageURL: imageURL, categories: categories, distance: distance, ratingImageURL: ratingImageURL, reviewCount: reviewCount, votes: votes)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.fourSquareID, forKey: "fourSquareID")
        aCoder.encodeObject(self.name, forKey: "name")
        aCoder.encodeObject(self.address, forKey: "address")
        aCoder.encodeObject(self.latitude, forKey: "latitude")
        aCoder.encodeObject(self.longitude, forKey: "longitude")
        aCoder.encodeObject(self.imageURL, forKey: "imageURL")
        aCoder.encodeObject(self.categories, forKey: "categories")
        aCoder.encodeObject(self.distance, forKey: "distance")
        aCoder.encodeObject(self.ratingImageURL, forKey: "ratingImageURL")
        aCoder.encodeObject(self.reviewCount, forKey: "reviewCount")
        aCoder.encodeObject(self.votes, forKey: "votes")
    }
    
    func convertToDictionary() -> [String : AnyObject] {
        var dictionary = [String : AnyObject]()
        dictionary["fourSquareID"] = self.fourSquareID
        dictionary["name"] = self.name
        dictionary["address"] = self.address
        dictionary["latitude"] = self.latitude
        dictionary["longitude"] = self.longitude
        dictionary["imageURL"] = self.imageURL
        dictionary["categories"] = self.categories
        dictionary["distance"] = self.distance
        dictionary["ratingImageURL"] = self.ratingImageURL
        dictionary["reviewCount"] = self.reviewCount
        dictionary["votes"] = self.votes
        return dictionary
    }
    
    class func convertFromDictionary(dictionary: [String : AnyObject]) -> Venue? {
        guard let id = dictionary["fourSquareID"] as? String, name = dictionary["name"] as? String, votes = dictionary["votes"] as? Int else { return nil }
        let address = dictionary["address"] as! String?
        let latitude = dictionary["latitude"] as! Double?
        let longitude = dictionary["longitude"] as! Double?
        let imageURL = dictionary["imageURL"] as! String?
        let categories = dictionary["categories"] as! String?
        let distance = dictionary["distance"] as! Int?
        let ratingURL = dictionary["ratingImageURL"] as! String?
        let reviewCount = dictionary["reviewCount"] as! Int?
        let venue = Venue(fourSquareID: id, name: name, address: address, latitude: latitude, longitude: longitude, imageURL: imageURL, categories: categories, distance: distance, ratingImageURL: ratingURL, reviewCount: reviewCount, votes: votes)
        return venue
        
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
