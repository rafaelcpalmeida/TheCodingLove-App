//
//  UIImageView.swift
//  Movies
//
//  Created by Miguel Duarte on 23/04/15.
//  Copyright (c) 2015 Miguel Duarte. All rights reserved.
//


import UIKit

public class ImageDownloadOperation: NSBlockOperation
{
    var objectHash:Int = 0
}

public extension UIImageView {
    
    struct DownloadQueue
    {
        static let loadQueue = NSOperationQueue()
    }
    
    
    public func setImageAsync(url:String, completion:(()->())? = nil)
    {
        var ops = DownloadQueue.loadQueue.operations.filter{ t in
            return t is ImageDownloadOperation && t.objectHash == self.hashValue
        }
        
        for op : AnyObject in ops{
            if let operation = op as? ImageDownloadOperation {
                operation.cancel()
            }
        }
        
        if let url = NSURL(string: url) {
            var newOperation = ImageDownloadOperation()
            weak var _self = self
            newOperation.addExecutionBlock({
                var urlRequest = NSURLRequest(URL: url, cachePolicy: .ReturnCacheDataElseLoad, timeoutInterval: 0)
                
                
                
                NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue(), completionHandler: { (response, data, error) -> Void in
                    
                    if(!newOperation.cancelled){
                        if(data != nil) {
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                _self?.image = UIImage.animatedImageWithData(data)
                            })
                        }
                    }
                    completion?()
                })
            })
            
            newOperation.objectHash = self.hashValue
            DownloadQueue.loadQueue.maxConcurrentOperationCount = 100
            DownloadQueue.loadQueue.addOperation(newOperation)
        }
    }
}


