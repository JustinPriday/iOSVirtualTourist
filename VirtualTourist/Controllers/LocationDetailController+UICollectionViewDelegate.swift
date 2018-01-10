//
//  LocationDetailController+UICollectionViewDelegate.swift
//  VirtualTourist
//
//  Created by Justin Priday on 2018/01/09.
//  Copyright © 2018 Justin Priday. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension LocationDetailController: UICollectionViewDataSource, UICollectionViewDelegate, NSFetchedResultsControllerDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LocationImageCell", for: indexPath) as! LocationImageCell
        
        let image = fetchedResultsController.object(at: indexPath)
        
        if image.imageData != nil {
            cell.loadingActivity.stopAnimating()
            cell.locationImage.image = image.image
            cell.cellBG.isHidden = true
        } else {
            cell.cellBG.isHidden = false
            cell.loadingActivity.startAnimating()
            cell.locationImage.image = nil
        }
        
        return cell
    }
    
    internal func updateButton() {
        if let selectedCount = imageCollection.indexPathsForSelectedItems?.count, selectedCount > 0 {
            imagesButton.setTitle("Remove Selected Images", for: .normal)
        } else {
            imagesButton.setTitle("New Collection", for: .normal)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Select item at \(indexPath.row), \(collectionView.indexPathsForSelectedItems?.count ?? 0) items selected")
        self.updateButton()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print("Deselect item at \(indexPath.row), \(collectionView.indexPathsForSelectedItems?.count ?? 0) items selected")
        self.updateButton()
    }
    
    // MARK: Core Data
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexPaths = [IndexPath]()
        deletedIndexPaths  = [IndexPath]()
        updatedIndexPaths  = [IndexPath]()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
            case .insert:
                insertedIndexPaths.append(newIndexPath!)
            case .update:
                updatedIndexPaths.append(indexPath!)
            case .delete:
                deletedIndexPaths.append(indexPath!)
            default:
                break
        }

    }
  
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        imageCollection.performBatchUpdates({
            for indexPath in self.insertedIndexPaths {
                self.imageCollection.insertItems(at: [indexPath as IndexPath])
            }
            for indexPath in self.deletedIndexPaths {
                self.imageCollection.deleteItems(at: [indexPath as IndexPath])
            }
            for indexPath in self.updatedIndexPaths {
                self.imageCollection.reloadItems(at: [indexPath as IndexPath])
            }
        }, completion: nil)
    }
}
