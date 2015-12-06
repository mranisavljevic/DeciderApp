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
    
    var accessToken: String?
    
    func requestAcessToken() {
        let baseURL = "https://graph.facebook.com/"
        guard let requestURL = NSURL(string: "\(baseURL)oauth/access_token?client_id=\(appId)&client_secret=\(appSecret)&grant_type=client_credentials") else { return }
        let request = NSMutableURLRequest(URL: requestURL)
        request.HTTPMethod = "GET"
        NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
            if let error = error {
                print(error.localizedDescription)
            }
            if let data = data {
                self.parseAccessToken(data)
            }
        }.resume()
    }
    
    func parseAccessToken(data: NSData) -> String? {
        guard let accessTokenString = String(data: data, encoding: NSUTF8StringEncoding) else { return nil }
        self.accessToken = accessTokenString.stringByReplacingOccurrencesOfString("access_token=", withString: "")
        return nil
    }

    
}
