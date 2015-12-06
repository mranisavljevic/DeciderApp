//
//  FacebookOAuthService.swift
//  DeciderApp
//
//  Created by Miles Ranisavljevic on 12/5/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

import UIKit

class FacebookOAuthService {
    
    static let sharedService = FacebookOAuthService()
    let appId = "1116971171648123"
    let appSecret = "577640f16504fd444e46628132933b54"
    
    func requestAcessToken() {
        let baseURL = "https://graph.facebook.com/"
        guard let requestURL = NSURL(string: "\(baseURL)oauth/access_token?client_id=\(appId)&client_secret=\(appSecret)&grant_type=client_credentials&redirect_uri=decider://") else { return }
        print(requestURL)
        let request = NSMutableURLRequest(URL: requestURL)
        request.HTTPMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
            if let error = error {
                print(error.localizedDescription)
            }
            if let data = data {
                if let httpResponse = response as? NSHTTPURLResponse {
                    print(httpResponse.statusCode)
                    print(httpResponse.allHeaderFields)
                    print(response)
                }
                self.parseAccessToken(data)
            }
        }.resume()
    }
    
    func parseAccessToken(data: NSData) -> String? {
        print(NSJSONSerialization.isValidJSONObject(data))
        do {
            let jsonObject = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
            if let rootObject = jsonObject as? [String : AnyObject] {
                print(rootObject)
            }
        } catch { return nil }
        return nil
    }

    
}
