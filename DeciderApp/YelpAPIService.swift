//
//  YelpAPIService.swift
//  DeciderApp
//
//  Created by Miles Ranisavljevic on 11/22/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

import UIKit
import Foundation

let kYelpAPIConsumerKey = "rvLclcIxCYzUZ4o8N4d5kw"
let kYelpAPIConsumerSecret = "K1ZFtHgf2mkPkYD3Q-0kKwg4rMU"
let kYelpAPIToken = "0B3IVHdG-v96cZd7-bqf1uzu0bRN2p2t"
let kYelpAPITokenSecret = "uc-TbZFcn9vzCpjYLbaBARvhyTM"
let kYelpAPIBaseSearchURL = "https://api.yelp.com/v2/search?"
let kYelpAPISearchLimit = 40

class YelpAPIService {
    
    class func searchVenues(searchTerm: String) {
        
        let timestamp = Int(NSDate().timeIntervalSince1970).description
        let urlString = "\(kYelpAPIBaseSearchURL)term=\(searchTerm)&cll=47.621679,-122.319763&limit=\(kYelpAPISearchLimit)"
        guard let url = NSURL(string: urlString) else { return }
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        request.addValue(kYelpAPIConsumerKey, forHTTPHeaderField: "oauth_consumer_key")
        request.addValue(kYelpAPIToken, forHTTPHeaderField: "oauth_token")
        request.addValue("HMAC-SHA1", forHTTPHeaderField: "oauth_signature_method")
        request.addValue(timestamp, forHTTPHeaderField: "oauth_timestamp")
        request.addValue("sadfljerfpoih4kn", forHTTPHeaderField: "oauth_nonce")
        let signature = NSString.SHA1("\(kYelpAPIConsumerSecret)&\(kYelpAPITokenSecret)")
        request.addValue("\(signature)", forHTTPHeaderField: "oauth_signature")
        
        NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
            if let response = response as? NSHTTPURLResponse {
                print(response)
                print(response.statusCode)
                print(error)
                print(data?.debugDescription)
            }
        }.resume()
    }
}













