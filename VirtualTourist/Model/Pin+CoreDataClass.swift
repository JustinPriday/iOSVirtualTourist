//
//  Pin+CoreDataClass.swift
//  VirtualTourist
//
//  Created by Justin Priday on 2017/11/29.
//  Copyright © 2017 Justin Priday. All rights reserved.
//
//

import Foundation
import CoreData
import MapKit


public class Pin: NSManagedObject, MKAnnotation {
    
    var downloading = false

    public var coordinate: CLLocationCoordinate2D {
        set {
            latitude = newValue.latitude
            longitude = newValue.longitude
        }
        get {
            return CLLocationCoordinate2D(latitude: latitude as Double, longitude: longitude as Double)
        }
    }
    
    convenience init(latitude: Double, longitude: Double, context: NSManagedObjectContext) {
        if let entity = NSEntityDescription.entity(forEntityName: "Pin", in: context) {

            self.init(entity: entity, insertInto: context)
            
            self.latitude = latitude
            self.longitude = longitude
        } else {
            fatalError("Unknown Entity Name");
        }
    }
    
    func deleteImages(context: NSManagedObjectContext) {
        let request = NSFetchRequest<Image>(entityName: "Image")
        request.predicate = NSPredicate(format: "pin == %@", self)
        
        do {
            let photos = try context.fetch(request as! NSFetchRequest<NSFetchRequestResult>) as! [Image]
            for photo in photos {
                context.delete(photo)
            }
        } catch { }
    }

}
