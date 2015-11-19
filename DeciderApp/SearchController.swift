//
//  SearchController.swift
//  DeciderApp
//
//  Created by Matthew Weintrub on 11/18/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

import UIKit

class SearchController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    
    var venues = []
    
    
    //MARK: - properties
    
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
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
        
        cell.venue = venues[indexPath.row] as! Venue
        
        return cell
    }
    
    
    // MARK: UISearchBarDelegate
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        print(searchBar.text)
        //        if let searchTerm = searchBar.text {
        //            if String.validateInput(searchTerm) {
        //                self.update(searchTerm)
        //            } else {
        //                let alert = UIAlertController(title: "No Bueno", message: "Your search for '\(searchBar.text!)' is no bueno.", preferredStyle: .Alert)
        //                let action = UIAlertAction(title: "lol", style: .Cancel, handler: nil)
        //                alert.addAction(action)
        //                presentViewController(alert, animated: true, completion: nil)
        //            }
        //        }
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        self.searchBar.resignFirstResponder()
        return true
    }
    
    
    
    
}
