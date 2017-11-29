//
//  Image+CoreDataProperties.swift
//  VirtualTourist
//
//  Created by Justin Priday on 2017/11/29.
//  Copyright © 2017 Justin Priday. All rights reserved.
//
//

import Foundation
import CoreData


extension Image {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Image> {
        return NSFetchRequest<Image>(entityName: "Image")
    }

    @NSManaged public var title: String?
    @NSManaged public var pin: Pin?

}
