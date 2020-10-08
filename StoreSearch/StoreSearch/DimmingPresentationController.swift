//
//  DimmingPresentationController.swift
//  StoreSearch
//
//  Created by Admin on 07.10.2020.
//  Copyright © 2020 alec. All rights reserved.
//

import UIKit

class DimmingPresentationController: UIPresentationController {
    lazy var dimmingView = GradientView(frame: CGRect.zero)
    
    // Called when a new PresentationController should be displayed on the screen
    override func presentationTransitionWillBegin() {
        dimmingView.frame = containerView!.bounds
        
        containerView!.insertSubview(dimmingView, at: 0)
        
        // Animate background gradient view
        dimmingView.alpha = 0
        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { _ in
                self.dimmingView.alpha = 1
            }, completion: nil)
        }
    }
    
    override func dismissalTransitionWillBegin() {
        if let coordinator = presentedViewController.transitionCoordinator {
            coordinator.animate(alongsideTransition: { _ in
                self.dimmingView.alpha = 0
            }, completion: nil)
        }
    }
    
    // Leave the SearchViewController visible
    override var shouldRemovePresentersView: Bool {
        return false
    }
}
