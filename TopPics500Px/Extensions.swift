//
//  Extensions.swift
//  TopPics500Px
//
//  Created by Ryan de Kwaadsteniet on 2017/11/14.
//  Copyright © 2017 Ryan de Kwaadsteniet. All rights reserved.
//

import UIKit

// this extention is a measure of good practice so I don't have to divide rgb values by rgb range each time
extension UIColor {
    static func rgb(_ red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

// extention for appling te visual format for my constraints using string interpolation ie. |-16-v[0]-16-|
extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

// initialise the image cache
let imageCache = NSCache<AnyObject, AnyObject>()

class CustomImageView: UIImageView {
    
    // images url
    var imageUrlString: String?
    
    // passes images url as param
    func loadImageUsingUrlString(_ urlString: String) {
        
        imageUrlString = urlString
        
        let url = URL(string: urlString)
        image = nil
        
        //checks to see whther image is in cache, similar to the nsuserdefaults key identification method
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        
        // start url session if not in cache
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, respones, error) in
            if error != nil {
                print(error!)
                return
            }
            
            // slow down execution of queue to prevent thrashing and swapping of images
            DispatchQueue.main.async(execute: {
                let imageToCache = UIImage(data: data!)
                
                // puts image into cache
                if self.imageUrlString == urlString {
                    self.image = imageToCache
                }
                
                imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
                self.image = UIImage(data: data!)
            })
                
        }).resume()
    }
        
}

