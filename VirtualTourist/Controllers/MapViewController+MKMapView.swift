//
//  MapViewController+MKMapView.swift
//  VirtualTourist
//
//  Created by Justin Priday on 2017/11/29.
//  Copyright © 2017 Justin Priday. All rights reserved.
//

import Foundation
import MapKit
import CoreData

extension MapViewController : MKMapViewDelegate {
    
    //MARK: Map View Delegates
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let pin = view.annotation as! Pin
        
        mapView.deselectAnnotation(pin, animated: false)
        
        isEditing ? deletePin(pin: pin) : viewPin(pin: pin)
    }
    
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
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        MapPreferences.shared.mapRegion = mapView.region
        MapPreferences.shared.save()
    }
    
    //MARK: Map Pin Helpers
    
    @objc func createPin(sender: UIGestureRecognizer) {
        if sender.state == .began {
            print("createPin")
            
            //TODO: Look at pre-cache

            let delegate = UIApplication.shared.delegate as! AppDelegate
            let stack = delegate.stack

            
            let point = sender.location(in: mapView)
            let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
            
            let pin = Pin(latitude: coordinate.latitude as Double, longitude: coordinate.longitude as Double, context: stack.context)
            
            mapView.addAnnotation(pin as MKAnnotation)

            stack.save()
        }
    }
    
    func viewPin(pin: Pin) {
        print("View Pin")
        
        let pinDetailController = storyboard!.instantiateViewController(withIdentifier: "PinDetail") as! LocationDetailController

        
        pinDetailController.pin = pin
        
        navigationController!.pushViewController(pinDetailController, animated: true)
    }
    
    func deletePin(pin: Pin) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let stack = delegate.stack
        
        mapView.removeAnnotation(pin)
        stack.context.delete(pin)
        stack.save()
        
        print("Pin deleted")
    }
    
    func fetchPins() -> [Pin] {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let stack = delegate.stack

        do {
            print("Pins loaded")
            return try stack.context.fetch(NSFetchRequest(entityName: "Pin")) as! [Pin]
        } catch {
            print("Could not load pins")
            return []
        }
    }
    
}
