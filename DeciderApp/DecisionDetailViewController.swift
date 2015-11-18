//
//  DecisionDetailViewController.swift
//  DeciderApp
//
//  Created by Miles Ranisavljevic on 11/17/15.
//  Copyright © 2015 creeperspeak. All rights reserved.
//

import UIKit

class DecisionDetailViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var venuesCollectionView: UICollectionView!
    @IBOutlet weak var voteButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var event: Event?
    
    var venues = [(String, Int)]()
    
    var selectedVenues = [Int]()
    
    var selectedVenueIndexPaths = [NSIndexPath]() {
        didSet {
            self.venuesCollectionView.reloadItemsAtIndexPaths(self.selectedVenueIndexPaths)
        }
    }
    
    class func identifier() -> String {
        return "DecisionDetailViewController"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.venuesCollectionView.dataSource = self
        self.venuesCollectionView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        setUpView()
        self.venues = self.sortVenuesByPopularity()
    }
    
    func setUpView() {
        guard let event = self.event else { return }
        self.titleLabel.text = event.eventTitle
        self.descriptionLabel.text = event.eventDescription
        self.dateTimeLabel.text = formatDateToString(event.eventDateTime)
        for venue in event.venues {
            self.venues.append(venue.0,venue.1)
        }
        self.venuesCollectionView.reloadData()
    }
    
    func formatDateToString(date: NSDate) -> String {
        return NSDateFormatter.localizedStringFromDate(date, dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
    }
    
    func addNewCellSelection(venueRow: Int) {
        let selectionCount = self.selectedVenues.count
        switch selectionCount {
        case 0...2:
            for path in self.selectedVenues {
                if venueRow == path {
                    return
                }
            }
            self.selectedVenues.append(venueRow)
            self.venues[venueRow].1++
            if self.selectedVenues.count == 3 {
                venues[0].1--
            }
        default:
            for i in 1...2 {
                if venueRow == self.selectedVenues[i] {
                    return
                }
            }
            var tempArray = self.selectedVenues
            tempArray[0] = tempArray[1]
            venues[tempArray[0]].1--
            tempArray[1] = tempArray[2]
            tempArray[2] = venueRow
            venues[tempArray[2]].1++
            self.selectedVenues = tempArray
        }
    }
    
    func addNewCellSelectionIndex(venueIndex: NSIndexPath) {
        let selectionCount = self.selectedVenueIndexPaths.count
        switch selectionCount {
        case 0...2:
            for path in self.selectedVenueIndexPaths {
                if venueIndex == path {
                    return
                }
            }
            self.selectedVenueIndexPaths.append(venueIndex)
        default:
            for i in 1...2 {
                if venueIndex == self.selectedVenueIndexPaths[i] {
                    return
                }
            }
            var tempArray = self.selectedVenueIndexPaths
            tempArray[0] = tempArray[1]
            tempArray[1] = tempArray[2]
            tempArray[2] = venueIndex
            self.selectedVenueIndexPaths = tempArray

        }
    }
    
    func sortVenuesByPopularity() -> [(String, Int)] {
        let sortedVenues = self.venues.sort { (a, b) -> Bool in
            return a.1 > b.1
        }
        return sortedVenues
    }
    
    @IBAction func voteButtonPressed(sender: UIButton) {
        guard let event = self.event else { return }
        if self.venues.count > 0 {
            ParseService.updateVotes(event.eventID, venues: self.venues, completion: { (success) -> () in
                if success {
                    self.venues = self.sortVenuesByPopularity()
                    self.selectedVenues = [Int]()
                    self.selectedVenueIndexPaths = [NSIndexPath]()
                    self.venuesCollectionView.reloadItemsAtIndexPaths(self.venuesCollectionView.indexPathsForVisibleItems())
                } else {
                    print("Voting unsuccessful")
                }
            })
        }
    }
    
    @IBAction func cancelButtonPressed(sender: UIButton) {
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //MARK: UICollectionView Datasource & Delegate & Flow Layout Methods
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return venues.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(DecisionDetailCollectionViewCell.identifier(), forIndexPath: indexPath) as! DecisionDetailCollectionViewCell
        cell.venue = self.venues[indexPath.row]
        switch self.selectedVenues.count {
        case 3:
            if indexPath.row == self.selectedVenues[0] {
                cell.selectionIndicatorLabel.hidden = true
            }
            if indexPath.row == self.selectedVenues[1] || indexPath.row == self.selectedVenues[2] {
                cell.selectionIndicatorLabel.hidden = false
            }
        case 1...2:
            for i in 0...self.selectedVenues.count - 1 {
                if indexPath.row == self.selectedVenues[i] {
                    cell.selectionIndicatorLabel.hidden = false
                }
            }
        default:
            cell.selectionIndicatorLabel.hidden = true
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let viewWidth = self.view.frame.width
        return CGSizeMake(viewWidth, 100.0)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.addNewCellSelection(indexPath.row)
        self.addNewCellSelectionIndex(indexPath)
    }
    
}
