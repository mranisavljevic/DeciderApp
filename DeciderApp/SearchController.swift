//
//  SearchController.swift
//  DeciderApp
//
//  Created by Matthew Weintrub on 11/18/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

import UIKit

protocol SearchControllerDelegate {
    func didUpdateSelectedVenuesWithVenues(venues: [Venue]?)
}

class SearchController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, CheckboxDelegate {
    
    var venues = [Venue]() {
        didSet {
            self.searchTableView.reloadData()
        }
    }
    
    var selectedVenues = [Venue]() {
        didSet {
            if let delegate = self.delegate {
                delegate.didUpdateSelectedVenuesWithVenues(self.selectedVenues)
            }
        }
    }
    
    var placeholderText = ""
    
    var delegate: SearchControllerDelegate?
    
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    //MARK: - setup functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchBar.delegate = self
        
        var placeholderOptions = ["Tacos","Burgers","Pizza","Coffee","Snacks","Food Truck","Surprise Me"]
        
        if self.placeholderText.characters.count == 0 {
            self.placeholderText = placeholderOptions[Int(rand()) % placeholderOptions.count]
        }
        self.searchBar.placeholder = self.placeholderText
        let searchTerm = self.placeholderText.stringByReplacingOccurrencesOfString(" ", withString: "")
        FourSquareService.searchVenues(searchTerm) { (success, data) -> () in
            if let data = data {
                FourSquareService.parseVenueResponse(data, completion: { (success, venues) -> () in
                    if let venues = venues{
                        NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                            self.venues = venues

                        })
                    }
                })
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - table view functions
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return venues.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Search Cell", forIndexPath: indexPath) as! SearchCell
        
        cell.venue = self.venues[indexPath.row]
        
        cell.checkboxButton.indexPath = indexPath
        cell.checkboxButton.datasource = self.venues
        cell.checkboxButton.delegate = self
        
        return cell
    }
    
    //MARK:  - UISearchBarDelegate
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
        
        if searchBar.text?.characters.count > 0 {
            guard let searchTerm = searchBar.text else {return}
            FourSquareService.searchVenues(searchTerm) { (success, data) -> () in
                if let data = data {
                    FourSquareService.parseVenueResponse(data, completion: { (success, venues) -> () in
                        if let venues = venues{
                            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                                self.venues = venues
                            })
                        }
                    })
                }
            }
            
        }
        
    }

    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    //MARK: CheckboxDelegate Method

    func checkboxDidFinishWithSelectedVenue(venue: Venue?) {
        guard let venue = venue else { return }
        if let index = self.selectedVenues.indexOf(venue) {
            self.selectedVenues.removeAtIndex(index)
        } else {
            self.selectedVenues.append(venue)
        }
    }
    
}
