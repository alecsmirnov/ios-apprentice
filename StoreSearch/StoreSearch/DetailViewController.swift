//
//  DetailViewController.swift
//  StoreSearch
//
//  Created by Admin on 07.10.2020.
//  Copyright © 2020 alec. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var searchResult: SearchResult!
    var downloadTask: URLSessionDownloadTask?
    
    @IBOutlet weak var popupView: UIView!
    
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var kindLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var priceButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.tintColor = UIColor(red: 20 / 255, green: 160 / 255, blue: 160 / 255, alpha: 1)
        
        popupView.layer.cornerRadius = 10
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(close))
        gestureRecognizer.cancelsTouchesInView = false
        gestureRecognizer.delegate = self
        
        view.addGestureRecognizer(gestureRecognizer)
        
        if searchResult != nil {
            updateUI()
        }
    }
    
    // Load the ViewController from the storyboard
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        modalPresentationStyle = .custom
        transitioningDelegate = self
    }
    
    deinit {
        print("deinit \(self)")
        downloadTask?.cancel()
    }
    
    // MARK: - Actions
    
    @IBAction func close() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func openInStore() {
        if let url = URL(string: searchResult.storeURL) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    // MARK: - Helper Methods
    func updateUI() {
        if let largeURL = URL(string: searchResult.imageLarge) {
            downloadTask = artworkImageView.loadImage(url: largeURL)
        }
        
        nameLabel.text = searchResult.name
        
        if searchResult.artist.isEmpty {
            artistNameLabel.text = "Unknown"
        } else {
            artistNameLabel.text = searchResult.artist
        }
        
        kindLabel.text = searchResult.type
        genreLabel.text = searchResult.genre
        
        // Show price
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = searchResult.currency
        
        let priceText: String
        if searchResult.price == 0 {
            priceText = "Free"
        } else if let text = formatter.string(from: searchResult.price as NSNumber) {
            priceText = text
        } else {
            priceText = ""
        }
        
        priceButton.setTitle(priceText, for: .normal)
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension DetailViewController: UIViewControllerTransitioningDelegate {
    // My own PresentationController
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?,
                                source: UIViewController) -> UIPresentationController? {
        return DimmingPresentationController(presentedViewController: presented, presenting: presenting)
    }
}

// MARK: - UIGestureRecognizerDelegate

extension DetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view === self.view
    }
}