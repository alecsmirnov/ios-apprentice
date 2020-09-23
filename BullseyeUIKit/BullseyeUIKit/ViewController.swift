//
//  ViewController.swift
//  BullseyeUIKit
//
//  Created by Admin on 23.09.2020.
//  Copyright © 2020 Alec. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private var currentValue = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func sliderMoved(_ slider: UISlider) {
        currentValue = lroundf(slider.value)
    }
    
    @IBAction func showAlert() {
        let message = "The value of the slider is: \(currentValue)"
        
        let alert = UIAlertController(title: "Perfect!", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Awesome", style: .default, handler: nil)
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

