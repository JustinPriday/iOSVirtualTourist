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
        if imagePath != nil {
            let fileURL = getImageFileURL()
            return UIImage(contentsOfFile: fileURL.path!)
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
    
    func getImageFileURL() -> NSURL {
        let fileName = (imagePath! as NSString).lastPathComponent
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let pathArray:[String] = [dirPath, fileName]
        let fileURL = NSURL.fileURL(withPathComponents: pathArray)
        return fileURL! as NSURL
    }
    
    public override func prepareForDeletion() {
        if (imagePath == nil) {
            return
        }
        let fileURL = getImageFileURL()
        if FileManager.default.fileExists(atPath: fileURL.path!) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path!)
            } catch let error as NSError {
                print(error.userInfo)
            }
        }
    }
    
}
