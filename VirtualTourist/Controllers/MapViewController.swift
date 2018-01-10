//
//  ViewController.swift
//  VirtualTourist
//
//  Created by Justin Priday on 2017/11/09.
//  Copyright © 2017 Justin Priday. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController {
    
    let DELETE_OFF_POSITION = -60.0
    let DELETE_ON_POSITION = 0.0
    
    @IBOutlet weak var deletePromptLocation: NSLayoutConstraint!
    @IBOutlet weak var deletePromptView: UIView!
    @IBOutlet weak var tNavigationItem: UINavigationItem!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = editButtonItem
        mapView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(createPin(sender:))))
        
        let pins = fetchPins()
        print("Startup with \(pins.count) pins")
        mapView.addAnnotations(fetchPins())
        
        MapPreferences.shared.load()
        if let mapRegion = MapPreferences.shared.mapRegion {
            mapView.setRegion(mapRegion, animated: true)
        }

        self.setEditing(false, animated: false)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        deletePromptLocation.constant = (editing) ? 0 : 60;
    }
    
}
