//
//  LocationDetailController.swift
//  VirtualTourist
//
//  Created by Justin Priday on 2017/11/29.
//  Copyright © 2017 Justin Priday. All rights reserved.
//

import UIKit
import CoreData
import MapKit

class LocationDetailController: UIViewController {
    
    let REGION_RANGE_METERS = 5000
    let CELL_SPACING = 4
    let CELL_COLUMNS = 3
    
    var pin: Pin? = nil
    
    @IBOutlet weak var imageCollection: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var infoMessage: UILabel!
    @IBOutlet weak var imagesButton: UIButton! //for reload and delete
    
    var selectedIndexes   = [IndexPath]()
    var insertedIndexPaths: [IndexPath]!
    var deletedIndexPaths : [IndexPath]!
    var updatedIndexPaths : [IndexPath]!
    
    lazy var fetchedResultsController: NSFetchedResultsController<Image> = {
        let fetchRequest = NSFetchRequest<Image>(entityName: "Image")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "pin == %@", self.pin!);
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let stack = delegate.stack
        
        let fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: stack.context, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultsController.delegate = self
        return fetchResultsController
    }()

    //MARK: UIViewController Delegates
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let pin = pin {
            mapView.addAnnotation(pin)
            mapView.setCenter(pin.coordinate, animated: true)
            
            let viewRegion: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(pin.coordinate, CLLocationDistance(REGION_RANGE_METERS), CLLocationDistance(REGION_RANGE_METERS))
            let adjustedRegion: MKCoordinateRegion = mapView.regionThatFits(viewRegion)
            
            mapView.setRegion(adjustedRegion, animated: true)
            
        }
        
        self.imagesButton.setTitle("New Collection", for: .normal)
        self.imageCollection.allowsMultipleSelection = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Images View Will Appear")
        do {
            try fetchedResultsController.performFetch()
            print("Images loaded from core data")
        } catch { }
        
        // Let's searh new photos if we don't have them yet
        if fetchedResultsController.fetchedObjects!.count == 0 {
            loadNewImageSet(pin: pin!)
        } else {
            self.imageCollection.isHidden = false
            self.infoMessage.isHidden = true
            self.imagesButton.isEnabled = true
        }
    }

    //MARK: IBAction
    
    @IBAction func imageButtonPressed(_ sender: Any) {
        if let selectedCount = imageCollection.indexPathsForSelectedItems?.count, selectedCount > 0 {
            print("Do Delete Images")
            if let indexPaths = imageCollection.indexPathsForSelectedItems {
                self.deleteSelectedImages(indexPaths: indexPaths)
            }
        } else {
            self.loadNewImageSet(pin: pin!)
        }
    }

}
