//
//  LocationDetailController+ImageManagement.swift
//  VirtualTourist
//
//  Created by Justin Priday on 2018/01/09.
//  Copyright © 2018 Justin Priday. All rights reserved.
//

import UIKit

extension LocationDetailController {
    
    func loadNewImageSet(pin: Pin) {
        print("Collect New Images")
        
        self.imageCollection.isHidden = true;
        self.infoMessage.isHidden = false;
        self.infoMessage.text = "Loading images."
        self.imagesButton.isEnabled = false;
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let stack = appDelegate.stack
        
        pin.deleteImages(context: stack.context)
        stack.save()
        
        FlickrClient.sharedInstance.getImagesForPin(pin: pin, stack: stack) { (success, error) in
            print("Got Images")
            
            if let objects = self.fetchedResultsController.fetchedObjects {
                print("Got \(objects.count) Images")
                if objects.count > 0 {
                    self.imageCollection.isHidden = false
                    self.infoMessage.isHidden = true
                    self.imagesButton.isEnabled = true
                } else {
                    self.imageCollection.isHidden = true
                    self.infoMessage.isHidden = false
                    self.infoMessage.text = "This pin has no images."
                    self.imagesButton.isEnabled = false
                }
            }
        }
    }
    
    func deleteSelectedImages(indexPaths:[IndexPath]) {
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let stack = delegate.stack

        indexPaths.forEach { index in
            let imageItem = fetchedResultsController.object(at: index)
            stack.context.delete(imageItem)
            imageCollection.deselectItem(at: index, animated: false)
            print("Delete Item at \(index.row)")
        }
        stack.save()
        self.updateButton()
    }
    
}
