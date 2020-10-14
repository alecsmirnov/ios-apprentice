//
//  UIImage+Resize.swift
//  MyLocations
//
//  Created by Admin on 03.10.2020.
//  Copyright © 2020 Alec. All rights reserved.
//

import UIKit

extension UIImage {
    func resized(withBounds bounds: CGSize) -> UIImage {
        let horizontalRatio = bounds.width / size.width
        let verticalRatio = bounds.height / size.height
        
        // Aspect Fit scales to the longest side. Aspect Fill scales to the shortest side
        // min - aspect fit. max - aspect fill
        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        
        draw(in: CGRect(origin: CGPoint.zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
