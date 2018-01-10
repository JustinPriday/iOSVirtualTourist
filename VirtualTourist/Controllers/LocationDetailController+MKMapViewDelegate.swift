//
//  LocationDetailController+MKMapViewDelegate.swift
//  VirtualTourist
//
//  Created by Justin Priday on 2018/01/10.
//  Copyright © 2018 Justin Priday. All rights reserved.
//

import Foundation
import MapKit

extension LocationDetailController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? Pin {
            let identifier = "Pin"
            var view: MKPinAnnotationView
            
            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
                dequeuedView.annotation = annotation
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = false
                view.animatesDrop = true
                view.isDraggable = false
            }
            return view
        }
        return nil
    }
}
