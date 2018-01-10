//
//  FlickrConvenience.swift
//  VirtualTourist
//
//  Created by Justin Priday on 2018/01/09.
//  Copyright © 2018 Justin Priday. All rights reserved.
//

import Foundation
import CoreData

extension FlickrClient {
    
    func getImagesForPin(pin: Pin, stack: CoreDataStack, completion:@escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        var pageNumber = 1
        
        if let pageCount = pin.pageCount {
            var numPagesInt = pageCount as! Int
            // We might only access the first 4000 images returned by a search, so limit the results
            if numPagesInt > 190 {
                numPagesInt = 190
            }
            pageNumber = Int((arc4random_uniform(UInt32(numPagesInt)))) + 1
            print("Getting photos for page number \(pageNumber) in \(pageCount) total pages")
        }
        
        let sortBy = "date-posted-desc"
        
        let parameters = [
            ParameterKeys.API_KEY: Constants.APIKey,
            ParameterKeys.METHOD: Methods.SEARCH,
            ParameterKeys.EXTRAS: ParameterValues.URL_M,
            ParameterKeys.FORMAT: ParameterValues.JSON_FORMAT,
            ParameterKeys.NO_JSON_CALLBACK: "1",
            ParameterKeys.SAFE_SEARCH: "1",
            ParameterKeys.BBOX: createBoundingBoxString(pin: pin),
            ParameterKeys.PAGE: pageNumber,
            ParameterKeys.PER_PAGE: 18,
            ParameterKeys.SORT: sortBy
            ] as [String : AnyObject]

        let _ = taskForGETMethod(url: nil, parameters: parameters, doParse: true) { (JSONResult, error) in
            if let error = error {
                var errorMessage = ""
                switch error.code {
                case 2:
                    errorMessage = "Network connection lost"
                    break
                default:
                    errorMessage = "A technical error occured while fetching images"
                    break
                }
                completion(false, errorMessage)
            } else {
                if let photosDictionary = JSONResult!["photos"] as? [String: AnyObject],
                    let photosArray = photosDictionary["photo"] as? [[String: AnyObject]],
                    let pageCount = photosDictionary["pages"] as? Int {
                    
                    DispatchQueue.main.async {
                        pin.pageCount = pageCount as NSNumber
                        
                        for photoDictionary in photosArray {
                            let imageURLString = photoDictionary["url_m"] as! String
                            let image = Image(imageURL: imageURLString, pin: pin, context: stack.context)
                            
                            print("Found image at \(image.imageURL ?? "No URL")")

                            self.downloadImageForPhoto(image: image, completionHandler: { (success, error) in
                                if success {
                                    DispatchQueue.main.async {
                                        stack.save()
                                        completion(true, nil)
                                    }
                                } else {
                                    DispatchQueue.main.async {
                                        completion(false,error)
                                    }
                                }
                            })
                            
//                            self.downloadImageForPhoto(photo) { (success, errorString) in
//                                if success {
//                                    dispatch_async(dispatch_get_main_queue(), {
//                                        CoreDataStackManager.sharedInstance().saveContext()
//                                        completionHandler(success: true, errorString: nil)
//                                    })
//                                } else {
//                                    dispatch_async(dispatch_get_main_queue(), {
//                                        completionHandler(success: false, errorString: errorString)
//                                    })
//                                }
//                            }
                        }
                        if let images = pin.images {
                            print("Got \(images.count) Images")
                        }
                        stack.save()
                        completion(true, nil)
                    }
                } else {
                    completion(false, "Unable to download Photos")
                }
            }
        }
    }
    
    func downloadImageForPhoto(image: Image, completionHandler: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
        let _ = taskForGETMethod(url: image.imageURL, parameters: [:], doParse: false) { (result, error) in
            if error != nil {
                image.imagePath = "unavailable"
                completionHandler(false, "Unable to download Photo")
            } else {
                if let result = result {
                    DispatchQueue.main.async {
                        let fileName = (image.imageURL! as NSString).lastPathComponent
                        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
                        let pathArray = [path, fileName]
                        let fileURL = NSURL.fileURL(withPathComponents: pathArray)!
                        
                        FileManager.default.createFile(atPath: fileURL.path, contents: result as? Data, attributes: nil)
                        
                        image.imagePath = fileURL.path
                        completionHandler(true, nil)
                    }
                } else {
                    completionHandler(false, "Unable to download Photo")
                }
            }
        }
    }
    
    func createBoundingBoxString(pin: Pin) -> String {
        
        let latitude = pin.coordinate.latitude
        let longitude = pin.coordinate.longitude
        
        /* Fix added to ensure box is bounded by minimum and maximums */
        let bottom_left_lon = max(longitude - BBoxParameters.BOUNDING_BOX_HALF_WIDTH, BBoxParameters.LON_MIN)
        let bottom_left_lat = max(latitude - BBoxParameters.BOUNDING_BOX_HALF_HEIGHT, BBoxParameters.LAT_MIN)
        let top_right_lon = min(longitude + BBoxParameters.BOUNDING_BOX_HALF_HEIGHT, BBoxParameters.LON_MAX)
        let top_right_lat = min(latitude + BBoxParameters.BOUNDING_BOX_HALF_HEIGHT, BBoxParameters.LAT_MAX)
        
        return "\(bottom_left_lon),\(bottom_left_lat),\(top_right_lon),\(top_right_lat)"
    }
    
}
