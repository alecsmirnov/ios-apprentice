//
//  RotateOutAnimationController.swift
//  StoreSearch
//
//  Created by Admin on 08.10.2020.
//  Copyright © 2020 alec. All rights reserved.
//

import UIKit

class RotateOutAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    // Very ugly and sad :(
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) {
            UIView.animateKeyframes(withDuration: transitionDuration(using: transitionContext),
                                    delay: 0, options: .calculationModeCubic, animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.334) {
                    fromView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7).rotated(by: .pi / CGFloat(4))
                }
                
                UIView.addKeyframe(withRelativeStartTime: 0.334, relativeDuration: 0.333) {
                    fromView.transform = CGAffineTransform(scaleX: 0.35, y: 0.35).rotated(by: .pi / CGFloat(2))
                }
                
                UIView.addKeyframe(withRelativeStartTime: 0.666, relativeDuration: 0.333) {
                    fromView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1).rotated(by: CGFloat(3) * CGFloat.pi / CGFloat(4))
                }
            }, completion: { finished in
                transitionContext.completeTransition(finished)
            })
        }
    }
}
