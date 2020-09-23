//
//  ViewController.swift
//  BullseyeUIKit
//
//  Created by Admin on 23.09.2020.
//  Copyright © 2020 Alec. All rights reserved.
//

import UIKit

private enum Settings {
    static let minimumScore = 1
    static let maximumScore = 100
}

class ViewController: UIViewController {
    private var currentValue = 0
    private var targetValue = 0
    private var score = 0
    private var round = 1
    
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var roundLabel: UILabel!
    
    @IBOutlet private weak var slider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startNewGame()
    }
    
    private func resetCurrentValueAndTargetValue() {
        currentValue = (Settings.minimumScore + Settings.maximumScore) / 2
        targetValue = Int.random(in: Settings.minimumScore...Settings.maximumScore)
    }
    
    private func startNewGame() {
        resetCurrentValueAndTargetValue()
        
        slider.value = Float(currentValue)
        
        updateLabels()
    }
    
    private func startNewRound() {
        resetCurrentValueAndTargetValue()
        
        slider.value = Float.random(in: Float(Settings.minimumScore)...Float(Settings.maximumScore))
        round += 1
        
        updateLabels()
    }
    
    func updateLabels() {
        targetLabel.text = String(targetValue)
        scoreLabel.text = String(score)
        roundLabel.text = String(round)
    }

    @IBAction private func sliderMoved(_ slider: UISlider) {
        currentValue = lroundf(slider.value)
    }
    
    @IBAction private func showAlert() {
        let difference = abs(targetValue - currentValue)
        let points = 100 - difference
        
        score += points
        
        let message = "The value of the slider is: \(currentValue)\n" +
                      "The target value is: \(targetValue)\n" +
                      "You scored \(points) points"
        
        let alert = UIAlertController(title: "Perfect!", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Awesome", style: .default, handler: nil)
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        startNewRound()
    }
}

