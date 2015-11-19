//
//  FourSquareService.swift
//  DeciderApp
//
//  Created by Miles Ranisavljevic on 11/18/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

import Foundation

let foursquareAPIClientID = "S2T4PAZANUMRA30MLLJKX5B0EB5U5S4SMFA4I5ZDNYAMQOHQ"
let foursquareAPIClientSecret = "WIPS4SUN1Z4B3G2N0NZS50OE4K4M3UDRSDYJIIKZLLKEOJLE"

let foursquareVenueSearchURL = "https://api.foursquare.com/v2/venues/search"

let cfLatLong = "47.625114,-122.335874"

let apiVersion = "20130815"

class FourSquareService {

    class func searchVenues(queryString: String, completion: (success: Bool, data: NSData?)->()) {
        let urlString = "\(foursquareVenueSearchURL)?client_id=\(foursquareAPIClientID)&client_secret=\(foursquareAPIClientSecret)&ll=\(cfLatLong)&v=\(apiVersion)&query=\(queryString)"
        guard let url = NSURL(string: urlString) else { return }
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
            if let data = data {
                completion(success: true, data: data)
            }
            if let _ = error {
                if let response = response as? NSHTTPURLResponse {
                    print("Error with code: \(response.statusCode)")
                }
            }
            completion(success: false, data: nil)
        }.resume()
    }
    
    class func parseVenueResponse(data: NSData, completion: (success: Bool, venues: [Venue]?)->()) {
        do {
            if let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? [String : AnyObject] {
                if let response = json["response"] as? [String : AnyObject] {
                    if let venues = response["venues"] as? [[String: AnyObject]] {
                        var venueArray = [Venue]()
                        for venue in venues {
                            if let id = venue["id"] as? String, name = venue["name"] as? String, location = venue["location"] as? [String : AnyObject], address = location["address"] as? String, distance = location["distance"] as? Int, lat = location["lat"] as? Double, long = location["lng"] as? Double, stats = venue["stats"] as? [String : AnyObject], userCount = stats["usersCount"] as? Int {
                                let venue = Venue(fourSquareID: id, name: name, address: address, latitude: lat, longitude: long, imageURL: "", categories: "", distance: distance, ratingImageURL: "", reviewCount: userCount)
                                venueArray.append(venue)
                            }
                        }
                        if venueArray.count > 0 {
                            completion(success: true, venues: venueArray)
                        }
                    }
                }
            }
        } catch {}
        completion(success: false, venues: nil)
    }
    
    
}
