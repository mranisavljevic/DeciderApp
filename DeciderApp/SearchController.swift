//
//  SearchController.swift
//  DeciderApp
//
//  Created by Matthew Weintrub on 11/18/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

import UIKit

class SearchController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var venues = [Venue(name: "1.McDonalds", address: "100 summit", imageURL: NSURL(fileURLWithPath: "http://placehold.it/80x80"), categories: "tacos", distance: "0.04mi", ratingImageURL: NSURL(fileURLWithPath: "http://placehold.it/80x15"), reviewCount: 44)]
    
    
    //MARK: - properties
    
    @IBOutlet weak var searchTableView: UITableView!
    
    //MARK: - setup functions
    override func viewDidLoad() {
        super.viewDidLoad()

        searchTableView.delegate = self
        searchTableView.dataSource = self
        
  
    }

    override func didReceiveMemoryWarning() {3
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - table view functions
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return venues.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchCell", forIndexPath: indexPath) as! SearchCell
        
        cell.venue = venues[indexPath.row]
        
        return cell
    }
    


}
