//
//  NetworkController.swift
//  PutAPI
//
//  Created by Patrick Pahl on 8/31/16.
//  Copyright © 2016 Patrick Pahl. All rights reserved.
//

import Foundation



class NetworkController {                           //fetch data here
    
    enum HTTPMethod: String {
        case Get = "GET"
        case Put = "PUT"
        case Post = "POST"
        case Patch = "PATCH"
        case Delete = "DELETE"
    }
    
    static func performRequestForURL(url: NSURL, httpMethod: HTTPMethod, urlParameters: [String: String]? = nil, body: NSData? = nil, completion:((data: NSData?, error: NSError?) -> Void)?) {
        
        let url = urlFromURLParameters(url, urlParameters: urlParameters)
        //creates URL with the parameters we gave it, i.e. urlParameters
        
        
        let mutableRequest = NSMutableURLRequest(URL: url)
        mutableRequest.HTTPBody = body
        // body is when we're posting.
        mutableRequest.HTTPMethod = httpMethod.rawValue
        //FYI: default method for HTTPMethod is GET
        
        let dataTask = NSURLSession.sharedSession().dataTaskWithRequest(mutableRequest) { (data, response, error) in        //Where the task gets executed.
            if let completion = completion {
                completion(data: data, error: error)
            }
        }
        dataTask.resume()                               //starting the task
    }
    
    //data task fetches the data. completion closure: Won't run until it does what it had to
    
    
    static func urlFromURLParameters(url: NSURL, urlParameters: [String: String]?) -> NSURL {
        
        let components = NSURLComponents(URL: url, resolvingAgainstBaseURL: true)
        
        components?.queryItems = urlParameters?.flatMap({NSURLQueryItem(name: $0.0, value: $0.1)})
        
        if let url = components?.URL {
            return url
        } else {
            fatalError("URL optional is nil")
        }
    }
}


