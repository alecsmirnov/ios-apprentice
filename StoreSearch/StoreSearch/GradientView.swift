//
//  GradientView.swift
//  StoreSearch
//
//  Created by Admin on 08.10.2020.
//  Copyright © 2020 alec. All rights reserved.
//

import UIKit

class GradientView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Сhange width and height proportionally when the superview it belongs to resizes due to being rotated
        // GradientView will always cover the same area that its superview covers
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Fully transparent color
        backgroundColor = UIColor.clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        autoresizingMask = [.flexibleWidth, .flexibleHeight]
    
        backgroundColor = UIColor.clear
    }
    
    override func draw(_ rect: CGRect) {
        // R, G, B, alpha
        let components: [CGFloat] = [0, 0, 0, 0.3,      // First color
                                     0, 0, 0, 0.7]      // Second color
        let locations: [CGFloat] = [0, 1]               // Color location in the gradient (0 - for first, 1 - for second)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient(colorSpace: colorSpace,
                                  colorComponents: components,
                                  locations: locations,
                                  count: locations.count)
        
        let x = bounds.midX
        let y = bounds.midY
        let centerPoint = CGPoint(x: x, y : y)
        let radius = max(x, y)
        
        let context = UIGraphicsGetCurrentContext()
        context?.drawRadialGradient(gradient!,
                                    startCenter: centerPoint,
                                    startRadius: 0,
                                    endCenter: centerPoint,
                                    endRadius: radius,
                                    options: .drawsAfterEndLocation)
    }
}
