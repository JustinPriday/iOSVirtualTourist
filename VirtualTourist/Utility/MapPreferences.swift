//
//  MapPreferences.swift
//  VirtualTourist
//
//  Created by Justin Priday on 2018/01/10.
//  Copyright © 2018 Justin Priday. All rights reserved.
//
//  Utility Object to save map region to Application Shared Preferences.

import Foundation
import MapKit

class MapPreferences: NSObject {
    
    let LATITUDE_KEY = "latitude"
    let LONGITUDE_KEY = "longitude"
    let LATITUDE_SPAN_KEY = "latitude_span"
    let LONGITUDE_SPAN_KEY = "longitude_span"

    var latitude: CLLocationDegrees = 0
    var longitude: CLLocationDegrees = 0
    var latitudeSpan: CLLocationDegrees = 0
    var longitudeSpan: CLLocationDegrees = 0

    var mapRegion: MKCoordinateRegion? {
        get {
            guard latitude != 0 && longitude != 0 && latitudeSpan != 0 && longitudeSpan != 0 else {
                return nil
            }
            
            return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: latitudeSpan, longitudeDelta: longitudeSpan))
        }
        
        set {
            latitude = newValue?.center.latitude ?? 0
            longitude = newValue?.center.longitude ?? 0
            latitudeSpan = newValue?.span.latitudeDelta ?? 0
            longitudeSpan = newValue?.span.latitudeDelta ?? 0
        }
    }
    
    static let shared = MapPreferences()
    
    func save() {
        let pref = UserDefaults.standard
        
        pref.set(latitude, forKey: LATITUDE_KEY)
        pref.set(longitude, forKey: LONGITUDE_KEY)
        pref.set(latitudeSpan, forKey: LATITUDE_SPAN_KEY)
        pref.set(longitudeSpan, forKey: LONGITUDE_SPAN_KEY)
        
        pref.synchronize()
    }
    
    func load() {
        let pref = UserDefaults.standard
        //Only record a valid region if all parameters are correctly available.
        if pref.object(forKey: LATITUDE_KEY) == nil ||
            pref.object(forKey: LONGITUDE_KEY) == nil ||
            pref.object(forKey: LATITUDE_SPAN_KEY) == nil ||
            pref.object(forKey: LONGITUDE_SPAN_KEY) == nil {
            latitude = 0
            longitude = 0
            latitudeSpan = 0
            longitudeSpan = 0
        } else {
            latitude = pref.double(forKey: LATITUDE_KEY)
            longitude = pref.double(forKey: LONGITUDE_KEY)
            latitudeSpan = pref.double(forKey: LATITUDE_SPAN_KEY)
            longitudeSpan = pref.double(forKey: LONGITUDE_SPAN_KEY)
        }
    }
    
}
