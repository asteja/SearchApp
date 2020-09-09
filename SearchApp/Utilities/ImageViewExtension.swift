//
//  ImageViewExtension.swift
//  SearchApp
//
//  Created by Saiteja Alle on 9/8/20.
//  Copyright © 2020 Saiteja Alle. All rights reserved.
//

import Foundation
import UIKit.UIImage

let imageCache = NSCache<NSString, UIImage>()
extension UIImageView {
    func loadImageUsingCache(withUrl urlString : String) {
        self.image = nil
        if let cachedImage = imageCache.object(forKey: urlString as NSString)  {
            self.image = cachedImage
            return
        }
        let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView.init(style: .gray)
        activityIndicator.center = CGPoint(x: self.bounds.size.width/2, y: self.bounds.size.height/2)
        addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        APIClient.loadImage(imageURL: urlString) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }

            if let image = UIImage(data: data!) {
                imageCache.setObject(image, forKey: urlString as NSString)
                self.image = image
                activityIndicator.removeFromSuperview()
            }
        }
    }
}
