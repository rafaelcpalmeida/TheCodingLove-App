//
//  DataManager.swift
//  TheCodingLove
//
//  Created by Rafael Almeida on 25/04/15.
//  Copyright (c) 2015 Rafael Almeida. All rights reserved.
//

import Foundation

let key = "insertAPIKeyHere"
let topPostURL = "http://api.tumblr.com/v2/blog/thecodinglove.com/posts/text?api_key=\(key)"

class DataManager
{
    class func getTopPostsWithSucess(success: ((postData: NSData!) -> Void)) {
        loadDataFromURL(NSURL(string: topPostURL)!, completion:{(data, error) -> Void in
            if let urlData = data {
                success(postData: urlData)
            }
        })
    }
    
    
    class func loadDataFromURL(url: NSURL, completion:(data: NSData?, error: NSError?) -> Void) {
        var session = NSURLSession.sharedSession()
        
        // Use NSURLSession to get data from an NSURL
        let loadDataTask = session.dataTaskWithURL(url, completionHandler: { (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
            if let responseError = error {
                completion(data: nil, error: responseError)
            } else if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    var statusError = NSError(domain:"com.raywenderlich", code:httpResponse.statusCode, userInfo:[NSLocalizedDescriptionKey : "HTTP status code has unexpected value."])
                    completion(data: nil, error: statusError)
                } else {
                    completion(data: data, error: nil)
                }
            }
        })
        
        loadDataTask.resume()
    }
}