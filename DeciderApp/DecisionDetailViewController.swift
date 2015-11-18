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
    
    var selectedVenues = [NSIndexPath]()
    
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
    
    func addNewCellSelection(venuePath: NSIndexPath) {
        let selectionCount = self.selectedVenues.count
        switch selectionCount {
        case 0...2:
            self.selectedVenues.append(venuePath)
        default:
            self.selectedVenues[2] = self.selectedVenues[1]
            self.selectedVenues[1] = self.selectedVenues[0]
            self.selectedVenues[0] = venuePath
        }
    }
    
    
    @IBAction func voteButtonPressed(sender: UIButton) {
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
            if indexPath == self.selectedVenues[2] {
                cell.selectionIndicatorLabel.hidden = true
            }
            if indexPath == self.selectedVenues[1] || indexPath == self.selectedVenues[0] {
                cell.selectionIndicatorLabel.hidden = false
            }
        case 1...2:
            for i in 0...self.selectedVenues.count - 1 {
                if indexPath == self.selectedVenues[i] {
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
        self.addNewCellSelection(indexPath)
        self.venuesCollectionView.reloadItemsAtIndexPaths(selectedVenues)
    }

}
