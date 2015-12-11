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



class NavigationController: UINavigationController, UIViewControllerTransitioningDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Status bar white font
        self.navigationBar.tintColor = UIColor.whiteColor()
    }
}


extension UINavigationItem {
    class func setItem(Item: UINavigationItem) {
        Item.titleView?.tintColor = UIColor.whiteColor()
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
    
    class func darkPurpleColor() -> UIColor {
        return UIColor(red: 18.0/255.0, green: 15.0/255.0, blue: 95.0/255.0, alpha: 1.0)
    }
    
}
