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
        let signature = buildURLSafeSignature(YelpAPIService())
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

    
    


//oauth_consumer_key	Your OAuth consumer key (from Manage API Access).
//oauth_token	The access token obtained (from Manage API Access).
//oauth_signature_method	hmac-sha1
//oauth_signature	The generated request signature, signed with the oauth_token_secret obtained (from Manage API Access).
//oauth_timestamp	Timestamp for the request in seconds since the Unix epoch.
//oauth_nonce	A unique string randomly generated per request.


    func buildURLSafeSignature() -> String {
    
    let stringToSign = kYelpAPIConsumerSecret+"&"
    let sha1Digest = stringToSign.hmacSha1(kYelpAPITokenSecret)
    let base64Encoded = sha1Digest.base64EncodedDataWithOptions(NSDataBase64EncodingOptions())
    
    return (NSString(data: base64Encoded, encoding: NSUTF8StringEncoding) as! String).urlEncode()
}

//private func loadDataFromURL(url: NSURL, completion:(data: NSData?, error: NSError?) -> Void) {
    
//    var session = NSURLSession.sharedSession()
    
//    let loadDataTask = session.dataTaskWithURL(url, completionHandler: { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
//        if let responseError = error {
//            completion(data: nil, error: responseError)
//        } else if let httpResponse = response as? NSHTTPURLResponse {
//            if httpResponse.statusCode != 200 {
//                var statusError = NSError(domain:"com.iteachcoding", code:httpResponse.statusCode, userInfo:[NSLocalizedDescriptionKey : "HTTP status code has unexpected value."])
//                completion(data: nil, error: statusError)
//            } else {
//                completion(data: data, error: nil)
//            }
//        }
//    })
    
//    loadDataTask.resume()
//}

}













