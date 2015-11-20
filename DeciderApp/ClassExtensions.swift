//
//  ClassExtensions.swift
//  DeciderApp
//
//  Created by Matthew Weintrub on 11/19/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

import UIKit

extension UINavigationBar {
    class func setNavBar(navBar: UINavigationBar) {
        navBar.barTintColor = UIColor.lightPurpleColor()
    }
}


extension UIColor {
    
    class func tealColor() -> UIColor {
        return UIColor(red: 162.0/255.0, green: 241.0/255.0, blue: 188.0/255.0, alpha: 1.0)
    }
    
    class func lightGreenColor() -> UIColor {
        return UIColor(red: 39.0/255.0, green: 220.0/255.0, blue: 179.0/255.0, alpha: 1.0)
    }
    
    class func lightPurpleColor() -> UIColor {
        return UIColor(red: 73.0/255.0, green: 67.0/255.0, blue: 230.0/255.0, alpha: 1.0)
    }
    
}