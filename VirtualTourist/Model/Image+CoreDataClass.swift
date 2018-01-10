//
//  Image+CoreDataClass.swift
//  VirtualTourist
//
//  Created by Justin Priday on 2017/11/29.
//  Copyright © 2017 Justin Priday. All rights reserved.
//
//

import Foundation
import UIKit
import CoreData


public class Image: NSManagedObject {
    
    var image: UIImage? {
        if imageData != nil {
            return UIImage(data: imageData! as Data)
        }
        return nil
    }
    
    convenience init(imageURL: String, pin: Pin, context: NSManagedObjectContext) {
        if let entity = NSEntityDescription.entity(forEntityName: "Image", in: context) {
            self.init(entity: entity, insertInto: context)
            self.imageURL = imageURL
            self.pin = pin
        } else {
            fatalError("Unknown Entity Name")
        }
    }
}
