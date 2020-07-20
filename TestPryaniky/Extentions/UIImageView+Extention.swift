//
//  UIImageView+Extention.swift
//  TestPryaniky
//
//  Created by Лилия Левина on 16.07.2020.
//  Copyright © 2020 Лилия Левина. All rights reserved.
//
import UIKit

extension UIImageView {
    
    public func imageFromServerURL(urlString: String, PlaceHolderImage:UIImage) {
        if self.image == nil {
            self.image = PlaceHolderImage
        }
        
        URLSession.shared.dataTask(with: NSURL(string: urlString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                print(error ?? "No Error")
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
            
        }).resume()
    }}
