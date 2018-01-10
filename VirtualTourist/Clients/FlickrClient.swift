//
//  FlickrClient.swift
//  VirtualTourist
//
//  Created by Justin Priday on 2018/01/09.
//  Copyright © 2018 Justin Priday. All rights reserved.
//

import Foundation

class FlickrClient: NSObject {
    
    var session: URLSession
    
    static let sharedInstance = FlickrClient()
    
    private override init() {
        session = URLSession.shared
        super.init()
    }
    
    // MARK: GET Methods
    func taskForGETMethod(url: String?, parameters: [String:AnyObject], doParse: Bool, completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: (url != nil) ?
            URL(string: url!)! :
            flickrURL(parameters: parameters))
        request.httpMethod = "GET"
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            if (doParse) {
                self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForGET)
            } else {
                completionHandlerForGET(data as AnyObject, nil)
            }
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    
    
    // MARK: Helper Methods
    
    func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
//            let range = Range(5..<data.count)
//            let newData = data.subdata(in: range) /* subset response data! */
            
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    func flickrURL(parameters: [String:AnyObject]) -> URL {
        var components = URLComponents()
        components.scheme = Constants.ApiScheme
        components.host = Constants.ApiHost
        components.path = Constants.ApiPath
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        print("FlickrURL: \(components)")
        
        return components.url!
    }

}
