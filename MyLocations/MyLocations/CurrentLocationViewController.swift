//
//  FirstViewController.swift
//  MyLocations
//
//  Created by Admin on 27.09.2020.
//  Copyright © 2020 Alec. All rights reserved.
//

import UIKit
import CoreLocation

class CurrentLocationViewController: UIViewController {
    let locationManager = CLLocationManager()
    var location: CLLocation?
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var tagButton: UIButton!
    @IBOutlet weak var getButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateLabels()
    }
    
    func updateLabels() {
        if let location = location {
            messageLabel.text = ""
            latitudeLabel.text = String(format: "%.8f", location.coordinate.latitude)
            longitudeLabel.text = String(format: "%.8f", location.coordinate.longitude)
            
            tagButton.isHidden = false
        } else {
            messageLabel.text = "Tap ’Get My Location’ to Start"
            latitudeLabel.text = ""
            longitudeLabel.text = ""
            addressLabel.text = ""
            
            tagButton.isHidden = true
        }
    }
    
    // MARK: - Actions
    
    @IBAction func getLocation() {
        let authStatus = CLLocationManager.authorizationStatus()
        
        if authStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
            return
        }
        
        if authStatus == .denied || authStatus == .restricted {
            showLocationServicesDeniedAlert()
            return
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        
        locationManager.startUpdatingLocation()
    }
    
    // MARK: - Helper Methods
    
    func showLocationServicesDeniedAlert() {
        let alert = UIAlertController(title: "Location Services Disabled",
                                      message: "Please enable location services for this app in Settings.",
                                      preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - CLLocationManagerDelegate

extension CurrentLocationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("didFailWithError \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        
        print("didUpdateLocations \(newLocation)")
        
        location = newLocation
        
        updateLabels()
    }
}
